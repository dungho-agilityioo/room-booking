require File.join(File.dirname(__FILE__), "../../config/require_all.rb")

class SendMail
  include Sidekiq::Worker
  def perform
    messages = PullMessageService.new.books_messages

    messages.each do |msg|
    	UserMailer.room_booking(msg.attributes).deliver
      msg.acknowledge!
    end
  end
end

