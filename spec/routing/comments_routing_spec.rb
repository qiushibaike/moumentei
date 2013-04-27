require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsController do
  it "should route to index" do
    expect(get('/articles/123/comments')).to route_to(:controller => 'comments', :action => 'index', :article_id => '123')
  end

  it "should route to create" do
    expect(post('/articles/123/comments')).to route_to(:controller => 'comments', :action => 'create', :article_id => '123')
  end
end