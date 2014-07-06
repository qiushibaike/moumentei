# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe Group, 'behaves like a tree' do
  let(:group1) { create :group }
  let(:group2) { create :group }
  describe '.roots' do
    it "finds correct root elements" do
      expect(Group.roots).to match_array([group1, group2])
    end
  end
  describe '#children' do
    let(:children) { create :group, parent_id: group1.id }
    it "should be have correct children elements" do
      expect(children.parent).to eq(group1)
    end
  end
end
