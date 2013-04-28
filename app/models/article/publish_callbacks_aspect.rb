# -*- encoding : utf-8 -*-
module Article::PublishCallbacksAspect
  def self.included(base)
    base.class_eval do
      define_model_callbacks :publish   
      before_save :check_publishing
      after_save :check_after_publishing
    end
  end

  def check_publishing 
    if status_changed? && status_was != 'publish' and status == 'publish'
      @publishing = true
      run_callbacks :publish, :before
    end
  end

  def check_after_publishing
    run_callbacks :publish, :after if @publishing
  end
end
