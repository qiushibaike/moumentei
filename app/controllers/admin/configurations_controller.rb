# -*- encoding : utf-8 -*-
class Admin::ConfigurationsController < Admin::BaseController
  def edit
    @config = Configuration.all
  end
  
  def update
    params[:config].save
  end

  def restart
    if request.post?
      
    end
  end

  protected
  def guess_deploy_method
    :passenger
  end

  def restart_method(deploy_method)
    case deploy_method
    when :passenger
      `touch #{Rails.root}/tmp/restart.txt`
    when :unicorn
    when :mongrel
    when :thin
    when :puma
    when :webrick
    end
  end
end
