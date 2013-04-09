# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Rating do
  before(:each) do
    @rating = Rating.new
  end

  it "should be valid" do
    @rating.should be_valid
  end
end
