# -*- encoding : utf-8 -*-
module BadgesHelper
  def show_badge(b)
    image_tag b.icon(:small), :title => b.title
  end
end
