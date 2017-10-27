class Api::V1::BookingsController < ApplicationController

  before_action :find_booking, only: [:show, :destroy, :update]
  before_action :find_room, only: [:create, :update], unless: :auth_with_api_key?
  skip_before_action :authenticate_request, only: [:show]
  swagger_controller :bookings, "Bookings Management"

  # GET /bookings
  # :nocov:
  swagger_api :index do
    summary "Fetches all Room Bookings of Current User"
    param :query, :limit, :integer, :optional, "Limit"
    param :query, :offset, :integer, :optional, "Offset"
    param_list :query, :filter, :String, :optional, "Filter For", ['', :available, :booked]
    param :query, :start_date, :DateTime, :optional, "Time Start"
    param :query, :end_date, :DateTime, :optional, "Time End"
    response :ok, "Success", :Room
    response :unauthorized
    response :unprocessable_entity
  end
  # :nocov:
  def index
    authorize Booking
    param! :limit, Integer
    param! :offset, Integer
    param! :filter, String, required: false

    # if only get list
    if params[:filter].blank?
      limit = params[:limit].to_i > 0 && params[:limit].to_i  || 10
      offset = params[:offset].to_i > 0 && params[:offset].to_i  || 0
      bookings = Booking.includes(:room, :user)
                  .limit(limit)
                  .offset(offset)

      if current_user.staff?
        total = Booking.where(user_id: current_user.id).count
        bookings = bookings.where(user_id: current_user.id)
      else
        total = Booking.count
      end

      respone_collection_serializer(bookings, limit, offset, total)
    # if is filter
    else
      param! :start_date, DateTime, required: true
      param! :end_date, DateTime, required: true

      start_date = params[:start_date].to_datetime
      end_date = params[:end_date].to_datetime

      # Get the rooms available on time range
      if params[:filter] == 'available'
        start_date = Time.zone.now if start_date < Time.zone.now

        json_response({ data: []}) if end_date < start_date

        rs = BookingService.get_availables( start_date, end_date )
        json_response({ data: rs })
      # Get the rooms booked on time range
      else
        room_bookings = BookingService.get_booked(params[:start_date], params[:end_date])
        render json: {
          data:
            ActiveModel::Serializer::CollectionSerializer.new(
              room_bookings, each_serializer: BookingSerializer
            )
        }
      end
    end
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
    response :created, "Created", :Booking
    response :unauthorized
    response :unprocessable_entity
  end
  # :nocov:
  def create
    if auth_with_api_key?
      next_booking
    else
      request_param

      authorize Booking
      booking = Booking.new(convert_param.merge(user_id: current_user.id))
      booking.save!
      respone_record_serializer(booking, BookingSerializer, :created)
    end
  end

  def next_booking
    auth_api_key
    find_booking
    BookingService.create_next_booking(@booking, 7)
    json_response( { successed: 'ok' })
  end

  # PUT /bookings/:id
  # :nocov:
  swagger_api :update do |api|
    summary "Update a Room Booking"
    param :path, :id, :integer, :required, "Booking ID"
    Api::V1::BookingsController::add_common_params(api)
    param_list :form, :state, :String, :optional, "State", [:available, :conflict]
    response :ok, "Success", :Booking
    response :unauthorized
    response :not_found
    response :unprocessable_entity
  end
  # :nocov:
  def update
    authorize @booking
    request_param
    data = convert_param.merge(user_id: current_user.id)
    if current_user.staff?
      data["state"] = @booking.overlaps? ? :conflict : :available
    end
    @booking.update!(data)

    respone_record_serializer(@booking, BookingSerializer)
  end

  # DELETE /bookings/:id
  # :nocov:
  swagger_api :destroy do
    summary "Delete a Room Booking of Current user"
    param :path, :id, :integer, :required, "Booking Id"
    response :no_content, "No Content", :Booking
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
    params.permit(:title, :description, :start_date, :end_date, :room_id, :daily, :state)
  end

  def convert_param
    book_params.each { |key, p| book_params[key] = p.to_datetime if [:start_date, :end_date].include? key.to_sym }
  end

  def find_room
    @room = Room.find(book_params[:room_id])
  end

  def find_booking
    id = params[:id]
    id = request.body.string.split('=').at(1).to_i if auth_with_api_key?
    @booking = Booking.includes(:user, :room).find(id)
  end

  def request_param
    param! :title, String, required: true
    param! :room_id, Integer, required: true
    param! :start_date, DateTime, required: true
    param! :end_date, DateTime, required: true
    param! :daily, :boolean
  end

end
