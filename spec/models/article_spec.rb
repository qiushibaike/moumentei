# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Article do
  let(:group) { create :group }
  let(:article1) { create :article, :status => 'publish', :group => group }
  let(:article2) { create :article, :status => 'publish', :group => group }
  
  it "should navigate to correct record" do
    #article = Article.find
    #$stderr << article1.inspect << "\n" << article2.inspect
    article1
    article2
    article1.next_in_group.should eql(article2)
    article2.prev_in_group.should eql(article1)
  end

end
