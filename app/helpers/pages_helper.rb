# -*- encoding : utf-8 -*-
module PagesHelper
  def show_page(path)
    if page = @group.pages.find_by_path(path)
      raw(page.content)
    else
      raw("<!-- cannot find page of '#{path}' -->")
    end
  end  
end
