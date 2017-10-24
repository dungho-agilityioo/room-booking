require 'dotenv/load'

Sneakers.configure  amqp: ENV['RABBITMQ_URL'],
                    log: "log/sneakers.log"
