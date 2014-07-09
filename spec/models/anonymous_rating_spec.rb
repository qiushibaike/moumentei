
describe AnonymousRating do
  let(:article){ create :article }
  let(:user){ create :user }

  it 'does not rate again' do
    expect{
      AnonymousRating.vote('127.0.0.1', article, 1)
    }.to change(AnonymousRating, :count).by(1)
    article.reload
    expect(article.score).to eql(1)
    expect(article.pos).to eql(1)
    expect{
      AnonymousRating.vote('127.0.0.1', article, 1)
    }.not_to change(AnonymousRating, :count)
    article.reload
    expect(article.score).to eql(1)
    expect(article.pos).to eql(1)
  end
end