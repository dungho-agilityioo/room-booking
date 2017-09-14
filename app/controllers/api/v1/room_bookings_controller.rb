class Api::V1::RoomBookingsController < ApplicationController

  before_action :find_booking, only: [:show, :destroy]
  swagger_controller :books, "Books Management"

  # GET /books
  # :nocov:
  swagger_api :index do
    summary "Fetches all Room Bookings of Current User"
    param :query, :page, :integer, :optional, "Page Number"
    response :ok, "Success", :Room
    response :unauthorized
    response :not_found
  end
  # :nocov:
  def index
    authorize ActsAsBookable::Booking
    param! :page, Integer
    page = params[:page].present? && params[:page] || 1

    total = current_user.bookings.count

    room_bookings = current_user.bookings.includes(:bookable, :booker).page(page)

    respone_collection_serializer(room_bookings, page, total)
  end

  # GET /books/:id
  # :nocov:
  swagger_api :show do
    summary "Fetches a single Room Booking item of Current User"
    param :path, :id, :integer, :required, "Room Booking Id"
    response :ok, "Success", :Room
    response :unauthorized
    response :not_found
  end
  # :nocov:
  def show
    authorize @booking || ActsAsBookable::Booking
    if @booking.present?
      respone_record_serializer(@booking)
    else
      json_response({message: Message.not_found('Room Booking')}, :not_found)
    end
  end

  # POST /books
  # :nocov:
  swagger_api :create do |api|
    summary "Creates a new Room Booking"
    Api::V1::RoomBookingsController::add_common_params(api)
    param :form, :title, :string, :required, "Title"
    param :form, :project_id, :integer, :optional, "Project Id"
    param :form, :daily, :boolean, :optional, "Daily"
    response :created, "Success", :RoomBooking
    response :unauthorized
  end
  # :nocov:
  def create
    request_param

    authorize ActsAsBookable::Booking
    find_project_by_user if params[:project_id].present?
    find_room
    booking = current_user.book! @room, convert_param.merge(amount: 1)

    respone_record_serializer(booking, ActsAsBookable::BookingSerializer, :created)
  end

  # DELETE /books/:id
  # :nocov:
  swagger_api :destroy do
    summary "Delete a Room Booking of Current user"
    param :path, :id, :integer, :required, "Room Booking Id"
    response :no_content, "Success", :RoomBooking
    response :unauthorized
    response :not_found
  end
  # :nocov:
  def destroy
    authorize @booking || ActsAsBookable::Booking

    if @booking.present?
      @booking.destroy
      json_response( nil, :no_content)
    else
      json_response({message: Message.not_found('Room Booking')}, :not_found)
    end
  end

  # POST /books/search
  # :nocov:
  swagger_api :search do |api|
    summary "Check Room Available in the range time"
    api.param_list :form, :type, :String, :required, "Search For", [:available, :booked]
    api.param :form, :time_start, :DateTime, :required, "Time Start"
    api.param :form, :time_end, :DateTime, :required, "Time End"
    response :ok, "Success", :RoomBooking
    response :unauthorized
    response :not_found
  end
  # :nocov:
  def search
    authorize ActsAsBookable::Booking
    param! :type, String, required: true
    param! :time_start, DateTime, required: true
    param! :time_end, DateTime, required: true

    time_start = params[:time_start].to_datetime
    time_end = params[:time_end].to_datetime

    if params[:type] == 'available'
      rs = BooksSearchService.check_availability( time_start, time_end )
      if rs.present?
        json_response({ data: rs })
      else
        json_response(nil, :no_content )
      end
    else
      page = params[:page].present? && params[:page] || 1
      total = ReportService.get_booked(params[:time_start], params[:time_end]).count
      room_bookings = ReportService.get_booked(params[:time_start], params[:time_end]).page(page)
      respone_collection_serializer(room_bookings, page, total)
    end

  end

  private

  def book_params
    # whitelist params
    params.permit(:title, :description, :time_start, :time_end, :room_id, :daily, :project_id)
  end

  def convert_param
    books = book_params.except(:room_id)
    books.each { |key, p| books[key] = p.to_datetime if [:time_start, :time_end].include? key.to_sym }
  end

  def find_room
    @room = Room.find(book_params[:room_id])
  end

  def find_booking
    @booking = current_user.bookings.where(id: params[:id]).first
  end

  def request_param
    param! :title, String, required: true
    param! :room_id, Integer, required: true
    param! :time_start, DateTime, required: true
    param! :time_end, DateTime, required: true
    param! :project_id, Integer
    param! :daily, :boolean
  end

  def find_project_by_user

    project = @current_user.projects.where(id: params[:project_id])

    unless project.present?
      raise(ActiveRecord::RecordNotFound, 'Project Not Found')
    end
  end
end
