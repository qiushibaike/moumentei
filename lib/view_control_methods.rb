# -*- encoding : utf-8 -*-
module ViewControlMethods
  def body_attributes(opt=nil)
    @body_attributes ||= {}
    return @body_attributes unless opt
    @body_attributes.reverse_merge!(opt)
  end
  #alias body_attributes= body_attributes
  
  protected :body_attributes
  def self.included(base)
    base.helper_method :body_attributes
  end
end
