class UserSerializer < ActiveModel::Serializer
  attributes *%i(id login avatar)

  def avatar
    p = {}
    if object.avatar.file?
      p[:original] = object.avatar.url(:original)
    end
    p
  end
end
