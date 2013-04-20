require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsController do
  context "there is an article with some comments" do
    let(:article){create :article}
    let(:comments){create_list :comment, rand(3..10), :status => 'publish', :article => article}
    it "should show comments" do
      comments #force load
      get :index, :article_id => article.id

      assigns(:comments).should_not be_empty
      assigns(:comments).should match_array(comments)
    end    
    it "should create comment" do
      comment = {:content => 'test'}
      post :create, :article_id => article.id, :comment => comment
      assigns(:comment).should be_kind_of(Comment)
      assigns(:comment).content.should == comment[:content]
      assigns(:comment).article_id.should == article.id
    end
  end

  context "there is neither article nor comments" do
    it "should show 404" do
      get :index, :article_id => rand(100)
      assigns(:comments).should be_nil
      response.status.should == 404
    end
    it "should not create comment without an article" do
      comment = {:content => 'test'}
      post :create, :article_id => rand(100), :comment => comment
      response.status.should == 404
      assigns(:comment).should be_nil 
    end
  end
end