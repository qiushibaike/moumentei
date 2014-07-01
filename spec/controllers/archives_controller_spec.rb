require 'spec_helper'
require 'article'
describe ArchivesController do
  let(:today){Date.today}
  let(:group) { create :group }
  let(:articles) { create_list :article, 10, group_id: group.id }

  describe '#show' do
    it "shows articles" do
      articles
      get 'show', group_id: 1, id: today.strftime("%Y-%m-%d")
    end
  end
end