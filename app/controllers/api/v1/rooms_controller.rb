class Api::V1::RoomsController < ApplicationController
	before_action :find_room, only: [:show, :update, :destroy]
  swagger_controller :room, "Room Management"

  # GET /rooms
  # :nocov:
  swagger_api :index do
    summary "Fetches all Rooms"
    response :ok, "Success", :Room
    response :unauthorized
    response :not_found
  end
  # :nocov:
  def index
    @rooms = Room.all
    authorize Room
    json_response(@rooms)
  end

  # GET /rooms/:id
  # :nocov:
  swagger_api :show do
    summary "Fetches a single Room item"
    param :path, :id, :integer, :required, "Room Id"
    response :ok, "Success", :Room
    response :unauthorized
    response :not_found
  end
  # :nocov:
  def show
    authorize @room
    json_response(@room)
  end


  # POST /rooms
  # :nocov:
  swagger_api :create do
    summary "Creates a new Room"
    param :form, :name, :string, :required, "Room Name"
    response :created, "Success", :Room
    response :unauthorized
  end
  # :nocov:
  def create
    @room = Room.new(room_params)
    authorize @room
    if @room.save
      json_response(@room, :created)
    else
      json_response(@room.errors.full_messages, :unprocessable_entity)
    end
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
  end
  # :nocov:
  def update
    authorize @room
    if @room.update(room_params)
      json_response(@room, :ok)
    else
      json_response(@room.errors.full_messages, :unprocessable_entity)
    end
  end

  # DELETE /rooms/:id
  # :nocov:
  swagger_api :destroy do
    summary "Delete a Room"
    param :path, :id, :integer, :required, "Room Id"
    response :no_content, "Success", :Room
    response :unauthorized
    response :not_found
  end
  # :nocov:
  def destroy
    authorize @room
    @room.destroy
    json_response( nil, :no_content)
  end

  private

  def room_params
    # whitelist params
    params.permit(:name)
  end

  def find_room
    @room = Room.find(params[:id])
  end

end
