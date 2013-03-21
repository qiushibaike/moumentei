module Article::PublishCallbacksAspect
  def self.included(base)
    base.class_eval do
      define_callbacks :before_publish, :after_publish
      before_save :check_publishing
      after_save :check_after_publishing
    end
  end

  def check_publishing 
    if status_changed? && status_was != 'publish' and status == 'publish'
      @publishing = true
      run_callbacks :before_publish
    end
  end

  def check_after_publishing
    run_callbacks :after_publish if @publishing
  end
end