# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ArticlesHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should include the Admin::ArticlesHelper" do
    included_modules = self.metaclass.send :included_modules
    included_modules.should include(Admin::ArticlesHelper)
  end
  
end
