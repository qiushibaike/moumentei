require 'spec_helper'
describe SessionsController do
  describe "route recognition" do
    it "should generate params from GET /login correctly" do
      expect(:get => '/login').to route_to( {:controller => 'sessions', :action => 'new'})
    end
    it "should generate params from POST /session correctly" do
      expect(:post => '/session').to route_to({:controller => 'sessions', :action => 'create'})
    end
    it "should generate params from DELETE /session correctly" do
      expect(:delete => '/logout').to route_to({:controller => 'sessions', :action => 'destroy'})
    end
  end

  describe "named routing" do
    it "should route session_path() correctly" do
      session_path().should == "/session"
    end
    it "should route new_session_path() correctly" do
      new_session_path().should == "/session/new"
    end
  end  

  describe "route generation" do
    it "should route the new sessions action correctly" do
      url_for(:controller => 'sessions', :action => 'new', :only_path => true).should == "/login"
    end
    it "should route the create sessions correctly" do
      url_for(:controller => 'sessions', :action => 'create', :only_path => true).should == "/session"
    end
    it "should route the destroy sessions action correctly" do
      url_for(:controller => 'sessions', :action => 'destroy', :only_path => true).should == "/logout"
    end
  end  
end