require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Score do
  before(:each) do
    @score = Score.new
  end

  it "should be valid" do
    @score.should be_valid
  end
end
