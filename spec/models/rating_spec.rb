# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Rating do
  let(:article) { create :article }
  let(:user) { create :user }
  context "when there is a positive rating" do
    subject(:rating) { create :rating, user: user, article: article, score: 1}
    it {should be_valid}
    it "should be found by pos" do
      rating
      expect(Rating.pos.count).to eq(1)
      expect(Rating.neg.count).to eq(0)
    end
  end

  context "when user has already rated the article" do
    before { create :rating, user: user, article: article }
    it "should be uniqueness for user and article" do
      r= Rating.new
      r.user_id = user.id
      r.article_id = article.id
      r.score = 1
      expect(r.save).to be false
      expect(r).not_to be_valid
      #r.errors[:article_id].should_not be_empty
    end
  end
end
