require File.dirname(__FILE__) + '/../spec_helper'

describe ArticlesHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should include the ArticlesHelper" do
    included_modules = self.metaclass.send :included_modules
    included_modules.should include(ArticlesHelper)
  end
  
end
