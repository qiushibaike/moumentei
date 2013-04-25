require 'spec_helper'

describe AnonymousRating do
  let(:article){ create :article }
  let(:user){ create :user }

  it 'should do something' do
    lambda{
      AnonymousRating.vote('127.0.0.1', article, 1)
    }.should change(AnonymousRating, :count).by(1)
    article.reload
    article.score.should == 1
    article.pos.should == 1
  end
end