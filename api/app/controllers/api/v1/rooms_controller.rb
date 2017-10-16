module Api
  module V1
    class RoomsController < ApplicationController
    	before_action :find_room, only: [:show, :update, :destroy]
      swagger_controller :room, "Rooms Management"
      skip_before_action :authenticate_request, only: [:show]

      # GET /rooms
      # :nocov:
      swagger_api :index do
        summary "Fetches all Rooms"
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
        authorize Room
        param! :filter, String, required: false
        limit = params[:limit].to_i > 0 && params[:limit].to_i  || 10
        offset = params[:offset].to_i > 0 && params[:offset].to_i  || 0

        if params[:filter].blank?

          total = Room.count
          rooms = Room.limit(limit).offset(offset)

          respone_collection_serializer(rooms, limit, offset, total, RoomSerializer)
        else
          param! :start_date, DateTime, required: true
          param! :end_date, DateTime, required: true

          start_date = params[:start_date].to_datetime
          end_date = params[:end_date].to_datetime

          if params[:filter] == 'available'
            start_date = Time.zone.now if start_date < Time.zone.now

            json_response({ data: []}) if end_date < start_date

            rs = BookingService.get_availables( start_date, end_date )
            json_response({ data: rs })
          else
            total = ReportService.get_booked(start_date, end_date).count
            room_bookings = ReportService.get_booked(start_date, end_date).limit(limit).offset(offset)
            respone_collection_serializer(room_bookings, limit, offset, total)
          end
        end
      end

      # GET /rooms/:id
      # :nocov:
      swagger_api :show do
        summary "Fetches a single Room item"
        param :path, :id, :integer, :required, "Room Id"
        response :ok, "Success", :Room
        response :not_found
      end
      # :nocov:
      def show
        respone_record_serializer(@room, RoomSerializer)
      end

      # POST /rooms
      # :nocov:
      swagger_api :create do
        summary "Creates a new Room"
        param :form, :name, :string, :required, "Room Name"
        response :created, "Created", :Room
        response :unauthorized
        response :unprocessable_entity
      end
      # :nocov:
      def create
        room = Room.new(room_params)
        authorize room
        room.save!
        respone_record_serializer(room, RoomSerializer, :created)
      end

      # PUT /rooms/:id
      # :nocov:
      swagger_api :update do
        summary "Update a Room"
        param :path, :id, :integer, :required, "Room Id"
        param :form, :name, :string, :required, "Room Name"
        response :ok, "Success", :Room
        response :unauthorized
        response :not_found
        response :unprocessable_entity
      end
      # :nocov:
      def update
        authorize @room
        @room.update!(room_params)
        respone_record_serializer(@room, RoomSerializer, :ok)
      end

      # DELETE /rooms/:id
      # :nocov:
      swagger_api :destroy do
        summary "Delete a Room"
        param :path, :id, :integer, :required, "Room Id"
        response :no_content, "No Content", :Room
        response :unauthorized
        response :not_found
        response :unprocessable_entity
      end
      # :nocov:
      def destroy
        authorize @room
        @room.destroy!
        json_response( nil, :no_content)
      end

      private

      def room_params
        # whitelist params
        params.permit(:id, :name)
      end

      def find_room
        @room = Room.find(params[:id])
      end

    end
  end
end
