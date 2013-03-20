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

  describe '#has_role?', "with params <foo>" do
    context 'user has role <foo>' do
      before :each do
        @user.stub(:role_name_list).and_return ['foo']
      end

      subject { @user.has_role?('foo') }

      it { should == true }
    end

    context "user dosen't have role <foo>" do
      before :each do
        @user.stub(:role_name_list).and_return ['bar']
      end

      subject { @user.has_role?('foo') }

      it { should == false }
    end
  end

  describe '#role_names' do
    describe 'callback should always be a string' do
      subject { @user.role_names }

      it { should be_kind_of(String) }
    end

    describe 'callback contains all role names' do
      before :each do
        Rails.cache.delete "roles:"
        @user.roles.new(:name => 'foo')
        @user.roles.new(:name => 'bar')
      end

      subject { @user.role_names }

      it { should eq('foo bar') }
    end
  end

  describe "#role_name_list" do
    before :each do
      @user.roles.new(:name => 'foo')
      @user.roles.new(:name => 'bar')
    end

    it "should return role list" do
      @user.role_name_list.should be_kind_of(Array)
      @user.role_name_list.should include 'foo'
      @user.role_name_list.should include 'bar'
    end
  end

  describe "#add_role" do
    before do
      @role = create(:role)
    end

    it "should add a role to user" do
      @user.add_role(@role.name)
      @user.role_ids.should include @role.id
    end
  end

  describe "#remove_role" do
    before do
      @role = create(:role)
      @user.add_role @role.name
    end

    it "should remove role from user" do
      @user.remove_role @role.name
      @user.role_ids.should_not include @role.id
    end
  end

  describe '#has_any_role?' do
    before do
      @user.stub(:role_name_list).and_return ["foo", "bar"]
    end

    it "should return return true" do
      @user.has_any_role?("foo", "admin").should eq true
    end

    it "should return return false" do
      @user.has_any_role?("admin").should eq false
    end
  end

  describe "#has_all_role?" do
    before do
      @user.stub(:role_name_list).and_return ["foo", "bar"]
    end

    it "should return return false" do
      @user.has_all_role?("foo", "admin").should eq false
    end

    it "should return return true" do
      @user.has_all_role?("foo", "bar").should eq true
    end

    it "should return return true" do
      @user.has_all_role?("foo").should eq true
    end
  end
end