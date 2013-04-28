# -*- encoding : utf-8 -*-
module PostLock
  def self.included(base)
    if Rails.env.production?
      base.before_filter :check_lock_post
      base.after_filter :release_lock_post
    end
  end

  def check_lock_post
    return unless request.post?
    @lock_name = "L#{logged_in? ? current_user.id : request.session_options[:id]}"
    if Rails.cache.exist?(@lock_name, :raw => true)
      render :text => '提交的太快了，请稍候再试'
      return false
    end
    @lock_key = "#{Time.now.to_i}.#{rand()}"
    # release lock after 20 second
    Rails.cache.write(@lock_name, @lock_key, :expires_in => 20, :raw => true)
    logger.debug{"Lock with #{@lock_name}:#{@lock_key}"}
  end

  def release_lock_post
    if request.post? and @lock_name
      content = Rails.cache.read(@lock_name, :raw => true)
      logger.debug{"Current Lock: #{@lock_name}, #{@lock_key}, #{content}"}
      if content && content == @lock_key
        Rails.cache.delete(@lock_name)
      end
    end
  end
end
