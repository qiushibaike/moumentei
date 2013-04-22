# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe SessionsController do
  context "there exists a user" do
    let(:user) { create :user, :password => '123456', :password_confirmation => '123456' }
    it "should successfully login" do
      post :create, :login => user.login, :password => '123456'
      #response.should be_success
      session[:user_id].should == user.id
    end    
  end
  
  context "there is no such user" do
    it "should not login" do
      post :create, :login => 'test', :password => '123456'
      response.should_not be_success
      session[:user_id].should be_nil
      
    end
  end
end


