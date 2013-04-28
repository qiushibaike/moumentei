# -*- encoding : utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #protect_from_forgery # :secret => 'd7f14b6ea460ab510ef00c7049c8bb56'
  helper :all
  include AuthenticatedSystem
  include ViewControlMethods
  #theme_support
  alias_method :current_theme, :theme_name
  theme :select_theme
  has_mobile_fu
  attr_accessor :show_login

  protected
  def render_feed options = {}
    @options = options
    render :template => "common/rss.xml.builder", :layout => false, :content_type => 'text/xml'
  end

  # Handle public-facing errors by rendering the "error" liquid template
  def show_404 target=''
    show_error "Page \"#{target}\" Not Found", :not_found
  end

  def show_error(message = 'An error occurred.', status = :internal_server_error)
    @message = message
    render :template => 'common/error', :status => status
  end

  def select_domain group
    #if request.host.index(group.inherited(:domain))
    #     redirect_to "#{request.protocol}#{request.host}#{(request.port == 80 ? '' : request.port_string)}#{request.path}#{(request.query_string.empty? ? '' : '?' + request.query_string )}"
    return unless group
    return unless Setting.use_canonical_url
    domain = group.inherited(:domain)
    if request.get? and !domain.blank? and request.host != domain and request.format.html?
      redirect_to "#{request.protocol}#{domain}#{(request.port == 80 ? '' : request.port_string)}#{request.path}#{(request.query_string.empty? ? '' : '?' + request.query_string )}"
    end
  end

  # select a correct theme according to current group
  def select_theme
    theme = nil
    #response.headers['Cache-Control']='private'
    response.headers['Vary'] = 'User-Agent'
    ua = request.user_agent
    force_mobile_format if ua.blank?
    response.headers['Cache-Control'] = 'no-cache' if is_mobile_device?
    @group ||= Group.find(Setting.default_group) if Setting.default_group
    theme = @group.options[:theme] if not @group.blank? and not @group.options.blank? and @group.options.include?(:theme)
  end

  #  def default_url_options(options={})
  #    options.reverse_merge!({:format => request.format.to_sym})
  #  end

  # figure out which group to operate on
  # according to the requested host name or params[:domain]
  def find_group(group_id=params[:group_id]||params[:id])
    @group = if group_id
      Group.find(group_id)
    else
      Group.find_by_domain(request.host) || (Setting.default_group ? Group.find(Setting.default_group) : Group.first)
    end
    return show_404 unless @group
    select_domain @group if request.host != 'localhost' and Rails.env.production?
    return @group
  end
end
