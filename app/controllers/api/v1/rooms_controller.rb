class Api::V1::RoomsController < ApplicationController
  before_action :authenticate_api_v1_user!
	before_action :find_room, only: [:show, :update, :destroy]

  # GET /rooms
  def index
    @rooms = Room.all
    authorize Room
    json_response(@rooms)
  end

  # GET /rooms/:id
  def show
    authorize @room
    json_response(@room)
  end

  # POST /rooms
  def create
    @room = Room.new(room_params)
    authorize @room
    if @room.save
      json_response(@room, :created)
    else
      json_response(@room.errors.full_messages, :unprocessable_entity)
    end
  end

  # PUT /rooms
  def update
    authorize @room
    if @room.update(room_params)
      json_response(@room, :ok)
    else
      json_response(@room.errors.full_messages, :unprocessable_entity)
    end
  end

  # DELETE /rooms/:id
  def destroy
    authorize @room
    @room.destroy
    json_response( nil, :no_content)
  end

  private

  def room_params
    # whitelist params
    params.require(:room).permit(:name)
  end

  def find_room
    @room = Room.find(params[:id])
  end

end
