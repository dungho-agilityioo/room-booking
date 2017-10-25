FROM rabbitmq:alpine

RUN apk update && apk upgrade && apk add curl

RUN curl http://www.rabbitmq.com/community-plugins/v3.6.x/rabbitmq_delayed_message_exchange-0.0.1.ez > $RABBITMQ_HOME/plugins/rabbitmq_delayed_message_exchange-0.0.1.ez

RUN rabbitmq-plugins enable --offline rabbitmq_management
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange

EXPOSE 15671 15672
