require File.dirname(__FILE__) + '/../spec_helper'

describe ArchivesController do
  it "should route do day" do
    expect(get '/archives/2013-01-02').to route_to(:controller => 'archives', :action => 'show', :id => '2013-01-02')
  end
end