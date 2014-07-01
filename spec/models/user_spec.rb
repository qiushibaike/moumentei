describe User do
  subject(:user) {build(:user)}

  describe "#is_admin?" do
    context 'given user has a role named admin' do
      before :each do
        @user.stub(:has_role?).with('admin').and_return(true)
      end

      subject { @user.is_admin? }

      it { should == true }
    end

    context "given user has no role" do
      before :each do
        @user.stub(:has_role?).with('admin').and_return(false)
      end

      subject { @user.is_admin? }

      it { should == false }
    end
  end
end
