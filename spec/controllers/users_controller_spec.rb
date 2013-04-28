# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UsersController do
  def create_user(options = {})
    post :create, :user => { :login => 'quire', :email => 'quire@example.com',
      :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
  end  
  context "there is no user" do
    it 'should signup and activate successfully' do
      lambda do
        post :create, :user => {
          :login => 'test', 
          :email => 'test@test.com', 
          :password=>'123456', 
          :password_confirmation => '123456'}
        response.should be_success
      end.should change(User, :count).by(1)
      u = User.find_by_login('test')
      u.should_not be_nil 
      u.email.should == 'test@test.com'
      u.state.should == 'pending'
      u.activation_code.should_not be_blank
      get :activate, :activation_code => u.activation_code
      u.reload
      u.state.should == 'active'
    end
  end
  
  it 'should signs up user in pending state' do
    create_user
    assigns(:user).reload
    assigns(:user).should be_pending
  end

  it 'should signs up user with activation code' do
    create_user
    assigns(:user).reload
    assigns(:user).activation_code.should_not be_nil
  end

  it 'should requires login on signup' do
    lambda do
      create_user(:login => nil)
      $stderr << assigns[:user].inspect
      assigns[:user].errors[:login].should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end
  
  it 'requires password on signup' do
    lambda do
      create_user(:password => nil)
      assigns[:user].errors[:password].should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end
  
  it 'requires password confirmation on signup' do
    lambda do
      create_user(:password_confirmation => nil)
      assigns[:user].errors[:password_confirmation].should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end

  it 'requires email on signup' do
    lambda do
      create_user(:email => nil)
      assigns[:user].errors[:email].should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end
  
  it 'does not activate user with blank key' do
    get :activate, :activation_code => ''
    flash[:notice].should     be_nil
    flash[:error ].should_not be_nil
  end
  
  it 'does not activate user with bogus key' do
    get :activate, :activation_code => 'i_haxxor_joo'
    flash[:notice].should     be_nil
    flash[:error ].should_not be_nil
  end
end

