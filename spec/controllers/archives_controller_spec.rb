require 'spec_helper'
describe ArchivesController do
  let(:today){Date.today}
  let(:articles) { create_list :article, 10 }

  describe '#show' do
    it "shows articles" do
      get 'show', id: today.strftime("%Y-%m-%d")
    end
  end
end