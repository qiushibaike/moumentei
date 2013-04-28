# -*- encoding : utf-8 -*-
package :rabbitmq, :provides => :mq do
  description 'RabbitMQ Message Queue'
  apt 'rabbitmq-server'
end
