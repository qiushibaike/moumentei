# -*- encoding : utf-8 -*-
class BaseWorker
  def self.method_missing(selector, *args, &block)
    if selector.to_s =~ /^asynch?_(\w+)/ and method_defined? $1
      enqueue $1, *args, &block
    else
      super
    end
  end
  def self.enqueue(method, *args, &block)
    perform method, *args, &block
  end
  def self.perform(method, *args, &block)
    new.__send__ method, *args, &block
  end
  #include BackEnd::DelayedJob
  #include BackEnd::DelayedJob if Rails.env.development?
  def self.use backend
    include  BackEnd.const_get(backend.to_s.camelize)
  end
end
