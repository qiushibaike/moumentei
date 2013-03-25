# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe Group, 'behaves like a tree' do
  let(:group) { create :group }
  it "should be able to find correct root elements" do
    Group.roots.should have(2).groups
    Group.roots.should include(groups(:qiushi), groups(:secret))
  end
  
  it "should be have correct children elements" do
    groups(:secret).children.should have(1).group
    groups(:secret).children.should include(groups(:consult))
  end
end
