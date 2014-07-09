
describe ArticlesController do

  #Delete this example and add some real ones
  it "should use ArticlesController" do
    expect(controller).to be_an_instance_of(ArticlesController)
  end

  context "Given there is no article existing" do
    let(:user) { create :user }
    let(:group) { create :group }
    before do
      ArticlesController.any_instance.stub(:current_user).and_return(user)
    end
    it "should create article" do
      article = {title: 'test', content: 'it is a test', group_id: group.id}
      expect do
        post :create, article: article
      end.to change(Article, :count).by(1)
      expect(assigns(:article)).to be_persisted
      expect(assigns(:article).title).to eq(article[:title])
      expect(assigns(:article).content).to eq(article[:content])
      expect(assigns(:article).user_id).to eq( user.id)
      expect(assigns(:article).group_id).to eq( group.id)
    end
  end

  context "given an published article exists" do
    let(:article) { create :article, status: 'publish' }
    it "should show article" do
      get :show, id: article.id
      expect(assigns(:article)).to be_a_kind_of(Article)
      expect(assigns(:article)).to eq( article)
    end
    context "a user logged in" do
      let(:current_user){create :user}
      before(:each) do
        session[:user_id] = current_user.id
      end
      it "should be able to vote up the article" do
        #lambda{
        post :up, id: article.id
        expect(response).to be_redirect

        article.reload
        #}.should change(article, :score).by(1)
        article.score.should == 1
        article.pos.should == 1
        expect(current_user.ratings).not_to be_empty
      end
      it "should be able to vote down the article" do
        post :dn, id: article.id
        expect(response).to be_redirect
        article.reload
        article.score.should == -1
        article.neg.should == 1
        expect(current_user.ratings).not_to be_empty
      end
    end
  end
end
