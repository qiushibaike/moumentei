class UserSerializer < ActiveModel::Serializer
  attributes *%i(id login avatar)
  # json = @user.as_json(only: [:id, :login, :name])
  # json['user']['followers'] = @user.followers.count
  # json['user']['friends']   = @user.friends.count
  # json['user']['avatar']    = @user.avatar.url(:thumb)
  # json['user']['public_articles_count'] = @user.articles.public.signed.count
  # json['user']['charm'] = @user.charm
  # if logged_in?
  #   json['following'] = current_user.following?(@user)
  # end
  def avatar
    p = {}
    if object.avatar.file?
      p[:original] = object.avatar.url(:original)
    end
    p
  end
end
