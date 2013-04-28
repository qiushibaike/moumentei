# -*- encoding : utf-8 -*-
module Workling
  module ClassMethods    
    def inherited(subclass)
      Workling::Discovery.discovered << subclass
    end
  
    def enqueue(*args)
      Workling::Remote.run(self.to_s.dasherize, *args)
    end
  end
  
  module InstanceMethods
    def initialize
      super
      
      create
    end

    # Put worker initialization code in here. This is good for restarting jobs that
    # were interrupted.
    def create
    end
    
    # takes care of suppressing remote errors but raising Workling::WorklingNotFoundError
    # where appropriate. swallow workling exceptions so that everything behaves like remote code.
    # otherwise StarlingRunner and SpawnRunner would behave too differently to NotRemoteRunner.
    def dispatch_to_worker_method(method, options)
      begin
        self.send(method, options)
      rescue Exception => e
        raise e if e.kind_of?(Workling::WorklingError)
        logger.error "WORKLING ERROR: runner could not invoke #{ self.class }:#{ method } with #{ options.inspect }. error was: #{ e.inspect }\n #{ e.backtrace.join("\n") }"

        # reraise after logging. the exception really can't go anywhere in many cases. (spawn traps the exception)
        raise e if Workling.raise_exceptions?
      end
    end        
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    receiver.class_eval do
      cattr_accessor :logger
      @@logger ||= ::Rails.logger
    end
  end
end
