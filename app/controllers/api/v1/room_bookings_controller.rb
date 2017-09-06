class Api::V1::RoomBookingsController < ApplicationController

  before_action :find_booking, only: [:show, :destroy]

  # GET /room_bookings
  def index
    authorize ActsAsBookable::Booking
    param! :page, Integer
    page = params[:page].present? && params[:page] || 1

    total = current_user.bookings.count

    room_bookings = current_user.bookings.page(page)

    respone_collection_serializer(room_bookings, page, total)
  end

    # GET /room_bookings/:id
  def show
    authorize @booking || ActsAsBookable::Booking
    if @booking.present?
      respone_record_serializer(@booking)
    else
      json_response({message: Message.not_found('Room Booking')}, :not_found)
    end
  end

  # POST /room_bookings
  def create
    request_param

    authorize ActsAsBookable::Booking
    find_room
    booking = current_user.book! @room, convert_param.merge(amount: 1)

    respone_record_serializer(booking, :created)
  end

  # DELETE /room_bookings/:id
  def destroy
    authorize @booking || ActsAsBookable::Booking

    if @booking.present?
      @booking.destroy
      json_response( nil, :no_content)
    else
      json_response({message: Message.not_found('Room Booking')}, :not_found)
    end
  end

  # POST /room_bookings/search
  def search
    authorize ActsAsBookable::Booking
    param! :room_id, Integer, required: true
    param! :time_start, DateTime, required: true
    param! :time_end, DateTime, required: true
    find_room
    rs = @room.check_availability({
                time_start: params[:time_start],
                time_end: params[:time_end],
                amount: 1
              })
    if rs
      json_response(
        "the Room is available from #{params[:time_start].to_s} to #{params[:time_end].to_s}"
      )
    else
      json_response(
        "the Room is not available from #{params[:time_start].to_s} to #{params[:time_end].to_s}",
        :not_found
      )
    end
  end

  def room_booked
    authorize ActsAsBookable::Booking
    param! :page, Integer
    param! :time_start, DateTime
    param! :time_end, DateTime

    page = params[:page].present? && params[:page] || 1

    total = ReportService.get_booked(params[:time_start], params[:time_end]).count
    room_bookings = ReportService.get_booked(params[:time_start], params[:time_end]).page(page)

    respone_collection_serializer(room_bookings, page, total)
  end

  private

  def book_params
    # whitelist params
    params.permit(:title, :description, :time_start, :time_end, :room_id, :daily)
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
end
