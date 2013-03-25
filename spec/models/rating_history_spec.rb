# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe RatingHistory do
  before(:each) do
    @rating_history = RatingHistory.new
  end

  it "should be valid" do
    @rating_history.should be_valid
  end
end
