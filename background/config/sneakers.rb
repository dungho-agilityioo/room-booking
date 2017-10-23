require 'dotenv/load'

begin
  bunny = Bunny.new
  Sneakers.configure bunny
rescue Bunny::TCPConnectionFailed => e
  puts "@@Error connecting: #{e.inspect}"
  retry
end
