class UserSession
  include Virtus.model
  extend ActiveModel::Naming
  attribute :login, String
  attribute :password, String
  # validates :login, :password, presence: true


end
