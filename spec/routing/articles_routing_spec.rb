require 'spec_helper'

require File.dirname(__FILE__) + '/../spec_helper'

describe ArticlesController do
  it "should route to \#show" do
    expect(:get '/articles/123').to route_to( {:controller => 'articles', :action => 'show', :id => '123'})
  end
  it "should route to vote" do
    expect(:post '/artlcles/123/up').to route_to(:controller => 'artlcles', :action => 'up', :id => '123')
    expect(:post '/artlcles/123/dn').to route_to(:controller => 'artlcles', :action => 'dn', :id => '123')
  end
end