require 'spec_helper'

require File.dirname(__FILE__) + '/../spec_helper'

describe ArticlesController do
  it "should route to \#show" do
    expect(:get => '/articles/123').to route_to( {:controller => 'articles', :action => 'show', :id => '123'})
  end
end