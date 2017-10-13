class Api::V1::BookingsController < ApplicationController

  before_action :find_booking, only: [:show, :destroy]
  before_action :find_room, only: [:create, :update]
  swagger_controller :bookings, "Bookings Management"
  skip_before_action :authenticate_request, only: [:show]

  # GET /bookings
  # :nocov:
  swagger_api :index do
    summary "Fetches all Room Bookings of Current User"
    param :query, :limit, :integer, :optional, "Limit"
    param :query, :offset, :integer, :optional, "Offset"
    param :path, :room_id, :integer, :required, "Room ID"
    response :ok, "Success", :Room
    response :unauthorized
  end
  # :nocov:
  def index
    authorize Booking
    param! :page, Integer
    limit = params[:limit].to_i > 0 && params[:limit].to_i  || 10
    offset = params[:offset].to_i > 0 && params[:offset].to_i  || 0
    room_id = params[:room_id]

    if current_user.admin?
      total = Booking.by_room(room_id).count
      bookings = Booking.by_room(room_id)
                  .includes(:room, :user)
                  .limit(limit)
                  .offset(offset)
    else
      total = current_user.bookings.where(bookable_id: room_id).count
      bookings = current_user.bookings
                    .where(bookable_id: room_id)
                    .includes(:room, :user)
                    .limit(limit)
                    .offset(offset)
    end

    respone_collection_serializer(bookings, limit, offset, total)
  end

  # GET /bookings/:id
  # :nocov:
  swagger_api :show do
    summary "Fetches a single Booking"
    param :path, :room_id, :integer, :required, "Room ID"
    param :path, :id, :integer, :required, "Room Booking Id"
    response :ok, "Success", :Room
    response :not_found
  end
  # :nocov:
  def show
    respone_record_serializer(@booking)
  end

  # POST /bookings
  # :nocov:
  swagger_api :create do |api|
    summary "Creates a new Room Booking"
    Api::V1::BookingsController::add_common_params(api)
    param :form, :title, :string, :required, "Title"
    param :form, :description, :string, :optional, "Description"
    param :form, :daily, :boolean, :optional, "Daily"
    response :created, "Created", :RoomBooking
    response :unauthorized
    response :unprocessable_entity
  end
  # :nocov:
  def create
    request_param

    authorize Booking
    booking = Booking.new(convert_param.merge(user_id: current_user.id))
    booking.save!
    respone_record_serializer(booking, BookingSerializer, :created)
  end


  # DELETE /bookings/:id
  # :nocov:
  swagger_api :destroy do
    summary "Delete a Room Booking of Current user"
    param :path, :room_id, :integer, :required, "Room Id"
    param :path, :id, :integer, :required, "Booking Id"
    response :no_content, "No Content", :RoomBooking
    response :unauthorized
    response :not_found
    response :unprocessable_entity
  end
  # :nocov:
  def destroy
    authorize @booking || Booking

    @booking.destroy!
    json_response( nil, :no_content)
  end


  private

  def book_params
    # whitelist params
    params.permit(:title, :description, :start_date, :end_date, :room_id, :daily)
  end

  def convert_param
    book_params.each { |key, p| book_params[key] = p.to_datetime if [:start_date, :end_date].include? key.to_sym }
  end

  def find_room
    @room = Room.find(book_params[:room_id])
  end

  def find_booking
    @booking = Booking.includes(:user, :room).find(params[:id])
  end

  def request_param
    param! :title, String, required: true
    param! :room_id, Integer, required: true
    param! :start_date, DateTime, required: true
    param! :end_date, DateTime, required: true
    param! :daily, :boolean
  end

end
