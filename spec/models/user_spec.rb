# -*- encoding : utf-8 -*-
require "spec_helper"

describe User do
  before do
    @user = build(:user)
  end

  describe "#is_admin?" do
    context 'has a role named admin' do
      before :each do
        @user.stub(:has_role?).with('admin').and_return(true)
      end

      subject { @user.is_admin? }

      it { should == true }
    end

    context "dosen't have a role named admin" do
      before :each do
        @user.stub(:has_role?).with('admin').and_return(false)
      end

      subject { @user.is_admin? }

      it { should == false }
    end
  end
end
