require 'rails_helper'
describe GroupsController do

  #Delete this example and add some real ones
  it "should use GroupsController" do
    # controller.should be_an_instance_of(GroupsController)
  end

  let(:group){create :group}
  it 'get /groups' do
    group
    get :index, format: :json
    expect(response.body).to eq({groups: [{id: group.id, name: group.name}]}.to_json)
  end

  it 'get /groups/:id' do
    group = create :group#, name: 'test'
    #groups = create_list :group, 10
    #create :user, status: 'active'
    get :show, id: group.id, format: :json
    expect(response.body).to eq({group: {id: group.id, name: group.name}}.to_json)
  end

end
