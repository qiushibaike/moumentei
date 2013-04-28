# -*- encoding : utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def how_long_ago_or_date( time )
    (sec=(Time.now-time).to_i)>86400 ? (time.utc + 8*3600).strftime("%Y.%m.%d %H:%M:%S") :
      ( (h=sec/3600)>0 ? "#{h}小时前" : "#{sec/60}分钟前" )
  end

  def skeleton name
    render "skeleton/#{name}"
  end

  def csrf_meta_tag
    tag :meta, :name => 'csrf-token', :content => form_authenticity_token if protect_against_forgery?
  end
  
  def title page_title
    content_for(:title){ page_title || @page_title}
  end
  
  def render_pagination
    render :partial => 'common/pagination'
  end

  def active_li_link(title, link, link_options={}, li_options={})
    link = url_for(link)
    content_tag :li, link_to(title, link, link_options), li_options.merge({:class => current_page?(link) && 'active'})
  end

  def content_for?(name)
    instance_variable_defined?("@content_for_#{name}")
  end
  
  def render_to(name, partial_name, opts={})
    content_for(name, render(opts.merge(:partial => partial_name)))
  end
  
  def render_skeleton
    render :template => 'layouts/skeleton'
  end
  
  def encrypt(content)
    Base64.encode64(content).rot13
  end
  
  def show_flash
    render :partial => 'common/flash', :object => flash
  end
  
  if Rails.env.production?
    def production_partial p
      render :partial => p
    end
    def javascript_min_include_tag(*sources)
      javascript_include_tag(*sources)
    end
  else
    def production_partial p; end
    def javascript_min_include_tag(*sources)
      javascript_include_tag *sources.collect{|s| s.is_a?(String) ? "#{s}.min" : s}
    end    
  end
end
