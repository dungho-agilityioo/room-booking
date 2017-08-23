class RoomsController < ApplicationController
	before_action :find_room, only: [:show, :update, :destroy]

  # GET /rooms
  def index
    @rooms = Room.all
    json_response(@rooms)
  end

  # POST /rooms
  def create
    @room = Room.create!(room_params)
    json_response(@room, :created)
  end

  # GET /rooms/:id
  def show
    json_response(@room)
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
