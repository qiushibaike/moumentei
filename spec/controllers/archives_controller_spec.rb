require 'spec_helper'
describe ArchivesController do
  let(:today){Date.today}
  before(:each) do
    #(today-30)..today
    @articles = create_list :article, 10
  end
  it "should show articles" do
    
  end
end