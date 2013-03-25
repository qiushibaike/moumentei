# -*- encoding : utf-8 -*-
class Admin::ThemesController < Admin::BaseController
  def index
    @themes = Theme.all
  end

  def edit
    
  end
  
  def update

  end
end
