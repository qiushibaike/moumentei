require File.dirname(__FILE__) + '/../spec_helper'

describe ArchivesController do
  it "should route to date" do
    expect(get '/archives/2013-01-02').to route_to(:controller => 'archives', :action => 'show', :id => '2013-01-02')
    expect(get '/archives/2013-01').to route_to(:controller => 'archives', :action => 'show', :id => '2013-01')
    expect(get '/archives/2013').to route_to(:controller => 'archives', :action => 'show', :id => '2013')
  end

  it "should route to date in group" do
    expect(get '/groups/1/archives/2013-04-05').to route_to(:controller => 'archives', :action => 'show', :group_id => '1', :id => '2013-04-05')
  end
end