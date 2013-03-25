# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe FavoritesHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should include the FavoritesHelper" do
    included_modules = self.metaclass.send :included_modules
    included_modules.should include(FavoritesHelper)
  end
  
end
