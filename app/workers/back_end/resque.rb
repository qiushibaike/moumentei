# -*- encoding : utf-8 -*-
module BackEnd::Resque
  def self.included(base)
    base.extend(ClassMethods)
  end
  module ClassMethods
    def enqueue(method, *args, &block)
      ::Resque.enqueue(self, method, *args)
    end

    def perform(method, *args)
      new.__send__ method, *args
    end    
  end
end
