require File.join(File.dirname(__FILE__), "../../config/require_all.rb")

class PullMessageService
  def initialize
    @pubsub = Google::Cloud::Pubsub.new( project: ENV['PROJECT_ID'],  keyfile: ENV['GOOGLE_PUS_SUB_KEY_FILE'] )
  end

	def books_messages
		topic = @pubsub.topic "send-mail-after-books"
		sub = topic.subscription "send-mail-after-books-subscription"
		sub.pull
	end
end
