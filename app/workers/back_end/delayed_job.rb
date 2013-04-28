# -*- encoding : utf-8 -*-
module BackEnd::DelayedJob
  def self.included(base)
    base.extend ClassMethods
  end
  module ClassMethods
    def enqueue(method, *args, &block)
      delay.perform method, *args, &block
    end
  end
end
