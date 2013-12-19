# -*- encoding : utf-8 -*-
module Article::PublishCallbacksAspect
  def self.included(base)
    base.class_eval do
      define_model_callbacks :publish
      around_save :check_publishing
    end
  end

  def check_publishing
    if status_changed? && status_was != 'publish' and status == 'publish'
      run_callbacks :publish do
        yield
      end
    else
      yield
    end
  end
end
