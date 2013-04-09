# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe ArticlesController do

  #Delete this example and add some real ones
  it "should use ArticlesController" do
    controller.should be_an_instance_of(ArticlesController)
  end
  context "given there is no article existing" do
    let(:user) { create :user }
    let(:group) { create :group }
    before do
      ArticlesController.any_instance.stub(:current_user).and_return(user)
    end
    it "should create article" do
      article = {:title => 'test', :content => 'it is a test', :group_id => group.id}
      lambda do
        post :create, :article => article
        #response.should be_success
      end.should change(Article, :count).by(1)
      assigns(:article).should be_persisted
      assigns(:article).title.should == article[:title]
      assigns(:article).content.should == article[:content]
      assigns(:article).user_id.should == user.id
      assigns(:article).group_id.should == group.id
    end    
  end

  context "given an article exists" do
    let(:article) { create :article }
    it "should show article" do
      get :show, :id => article.id
      assigns(:article).should be_a_kind_of(Article)
      assigns(:article).should == article
    end    
  end
end
