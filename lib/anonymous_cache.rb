require 'uri'
require 'fileutils'

module AnonymousCache

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def caches_page_for_anonymous(*pages)
      options = pages.extract_options!
      options[:only] = Array(options[:only]) + pages
      before_filter :check_cache_for_anonymous, options
      after_filter :cache_for_anonymous, options
    end
  end

  def check_cache_for_anonymous
    return unless perform_caching
    return if logged_in? or !request.get?
    @cache_path ||= anon_cache_path

    if content = Rails.cache.read(@cache_path)
      send_data(content,
        :type => 'text/html;charset=utf-8', :disposition => 'inline')
      return false
    end
  end

  def cache_for_anonymous
    return unless perform_caching
    return if logged_in?
    @cache_path ||=  anon_cache_path
    @expires_in ||= 1.hour
    Rails.cache.write(@cache_path, response.body, :expires_in => @expires_in.to_i)
  end

  protected :check_cache_for_anonymous
  protected :cache_for_anonymous
  private
    def anon_cache_path()
      path1 = File.join(request.host, current_theme.to_s, "#{request.path}.#{request.format.try(:to_sym)}")
      q = request.query_string
      path1 = "#{path1}?#{q}" unless q.empty?
      path1 = "#{path1}\#xhr" if request.xhr?
      logger.debug(path1)
      path1
    end
end
