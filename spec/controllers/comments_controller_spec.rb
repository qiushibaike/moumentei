
describe CommentsController do
  context "there is an article with some comments" do
    let(:article) { create :article }
    let(:comments) { create_list :comment, rand(3..10), status: 'publish', article: article }

    describe '#index' do
      context 'Given user logged in' do
        it "shows comments" do
          comments #force load
          get :index, article_id: article.id

          expect(assigns(:comments)).not_to be_empty
          expect(assigns(:comments)).to match_array(comments)
        end
      end

      context 'Given user not logged in' do
        it 'shows comments' do
          pending 'shows comments'
        end
      end
    end

    describe '#create' do
      it "should create comment" do
        comment = {content: 'test'}
        post :create, article_id: article.id, comment: comment
        expect(assigns(:comment)).to be_kind_of(Comment)
        expect(assigns(:comment).content).to eq( comment[:content])
        expect(assigns(:comment).article_id).to eq(article.id)
      end

      context 'Given author closed comment' do
        before { article.comment_status = 'closed' }
        it 'shows forbidden' do
          pending 'shows forbidden'
        end
      end
    end
  end

  context "there is neither article nor comments" do
    let(:article) { nil }
    describe '#index' do
      it "should show 404" do
        get :index, article_id: rand(100)
        expect(assigns(:comments)).to be_nil
        expect(response.status).to eq(404)
      end
    end
    it "should not create comment without an article" do
      comment = {content: 'test'}
      post :create, article_id: rand(100), comment: comment
      expect(response.status).to eq(404)
      expect(assigns(:comment)).to be_nil
    end
  end
end