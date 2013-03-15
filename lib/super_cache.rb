require 'uri'
require 'fileutils'
# for static-caching the generated html pages

module SuperCache
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def super_caches_page(*pages)
      return unless perform_caching
      options = pages.extract_options!
      options[:only] = Array(options[:only]) + pages
      before_filter :check_weird_cache, options
      after_filter :weird_cache, options
    end
  end
  
  def check_weird_cache
    return unless perform_caching 
    @cache_path ||= weird_cache_path
    
    if content = Rails.cache.read(@cache_path, :raw => true)
      return if content.size < 10
      logger.info "Hit #{@cache_path}"
      send_data(content,
        :type => request.format.to_s.strip, :disposition => 'inline')
      return false
    end
  end
  
  def weird_cache
    return unless perform_caching
    @cache_path ||= weird_cache_path
    @expires_in ||= 86400
    
    self.class.benchmark "Super Cached page: #{@cache_path}" do
      #logger.info response.body
      @cache_subject = Array(@cache_subject)
      @cache_subject.compact.flatten.select{|s|s.respond_to?(:append_cached_key)}.each do |subject|
        subject.append_cached_key @cache_path 
      end
      Rails.cache.write(@cache_path, response.body, :raw => true, :expires_in => @expires_in.to_i)
    end
  end
  
  protected :check_weird_cache
  protected :weird_cache
  private
    def weird_cache_path
      File.join request.host, request.path
    end
end
