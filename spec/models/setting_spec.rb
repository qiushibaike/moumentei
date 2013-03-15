require File.dirname(__FILE__) + '/../spec_helper'

describe Setting do
  before(:each) do
    @setting = Setting.new
  end

  it "should be valid" do
    @setting.should be_valid
  end
end
