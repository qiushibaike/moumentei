class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :picture, :created_at, :published_at
  has_one :user

  def picture
    p= {}
    if object.picture.file?
      p[:original] = object.picture.url(:original)
    end
    p
  end
end
