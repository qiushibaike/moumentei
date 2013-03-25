# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Article do
  let(:article1) { create :article }
  let(:article2) { create :article }
  
  it "should be valid" do
    #@article.should be_valid
  end
  
  it "should navigate to correct record" do
    #article = Article.find
    articles(:one).next_in_group.should eql(articles(:two))
    articles(:two).prev_in_group.should eql(articles(:one))
  end
  
end
