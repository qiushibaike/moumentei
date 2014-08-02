class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :picture, :created_at, :published_at, :pos, :neg, :public_comments_count, :anonymous
  has_one :user

  def include_user?
    !object.anonymous?
  end

  def picture
    p= {}
    if object.picture.file?
      p[:original] = object.picture.url(:original)
    end
    p
  end
end
