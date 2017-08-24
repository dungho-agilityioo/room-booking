class RoomsController < ApplicationController
	before_action :find_room, only: [:show, :update, :destroy]

  # GET /rooms
  def index
    @rooms = Room.all
    json_response(@rooms)
  end

  # GET /rooms/:id
  def show
    json_response(@room)
  end

  # POST /rooms
  def create
    @room = Room.new(room_params)
    if @room.save
      json_response(@room, :created)
    else
      json_response(@room.errors.full_messages, :unprocessable_entity)
    end
  end

  # PUT /rooms
  def update
    if @room.update(room_params)
      json_response(@room, :ok)
    else
      json_response(@room.errors.full_messages, :unprocessable_entity)
    end
  end

  # DELETE /rooms/:id
  def destroy
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
