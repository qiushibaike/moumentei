class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content
  has_one :user

  def include_user?
    !object.anonymous?
  end
end
