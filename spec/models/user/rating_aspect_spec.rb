require 'spec_helper'

describe User::RatingAspect do
	let(:user){ create :user }
	let(:article){ create :article }
	context 'user have not rated article yet' do
		describe '#rate' do
			it "should create rating" do
				lambda{
					user.rate article, 1
				}.should change(Rating, :count).by(1)
				r = Rating.last
				r.user.should == user
				r.article.should == article
			end
		end
		describe '#has_rated?' do
			it "should not has_rated" do
				user.has_rated?(article).should be_false
			end
		end
	end
	context 'user have already rated the article' do
		before do
			user.rate article, 1
		end

		describe '#has_rated?' do
			subject { user.has_rated?(article) }
			it { should be_true }
		end

		it "should not be able to vote again" do
		  lambda { user.rate article, 1 }.should_not change(article, :score)
		end
	end
	context "user is the article author" do
	  let(:article) { create :article, :user => user }
	  it "should not be able to vote to its own article" do
	    article.score.should == 0
	    lambda { user.rate article, 1 }.should_not change(article, :score)
	  end
	end
end