class Api::V1::BooksController < ApplicationController

  before_action :find_room, only: [:create]

  def create
    current_user.book! @room, convert_param.merge(amount: 1)
  end


  private

  def book_params
    # whitelist params
    params.require(:book).permit(:title, :description, :time_start, :time_end, :room_id)
  end

  def convert_param
    books = book_params.except(:room_id)
    books.each { |key, p| books[key] = p.to_datetime if [:time_start, :time_end].include? key.to_sym }
  end

  def find_room
    @room = Room.find(book_params[:room_id])
  end
end
