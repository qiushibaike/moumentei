# -*- encoding : utf-8 -*-
module User::AuthenticationAspect
  extend ActiveSupport::Concern
  module ClassMethods
    # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
    #
    # uff.  this is really an authorization, not authentication routine.
    # We really need a Dispatch Chain here or something.
    # This will also let us return a human error message.
    #
    def authenticate(login, password)
      return nil if login.blank? || password.blank?
      if login.include?('@')
        u = in_state(:active).where(email: login).first # need to get the salt
        u = in_state(:pending).where(email: login).first unless u
      else
        u = in_state(:active).where(login: login).first # need to get the salt
        u = in_state(:pending).where(login: login).first unless u
      end
      u && u.authenticated?(password) ? u : nil
    end

    def reset_password(p)
      user = where("login = :login and email = :email", *p).first
      if user and not user.deleted? and not user.suspended?
        passwd = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )[0,8]
        user.password = passwd
        user.password_confirmation = passwd
        user.state = 'active'
        user.save
      end
      user
    end

  end



    def login=(value)
      write_attribute :login, (value ? value.downcase : nil)
    end

    def email=(value)
      write_attribute :email, (value ? value.downcase : nil)
    end

    def self.password_digest(password, salt)
      Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end

    #####{{{{
    def forget_me
      self.remember_token_expires_at = ''
      self.remember_token            = ''
      save(validate: false)
    end


  #  def self.lost_confirm(p)
  #    user = find(:first, conditions:["login = :login and email = :email", p])
  #    if user
  #      user.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )# 生成确认代码
  #      user.save
  #    end
  #    user
  #  end
  #
  #  def self.lost_modify_passwd(p)
  #    user = find_by_activation_code(p[:activation_code])
  #    if user
  #      user.password = p[:password]
  #      user.activation_code = nil
  #      user.crypted_password = user.encrypt(p[:password])
  #      user.save
  #    end
  #    user
  #  end
    def make_activation_code
        self.deleted_at = nil
        self.activation_code = self.class.make_token
    end
    def change_to_pending_when_email_change
      if active? and email_changed?
        self.state = 'pending'
        self.make_activation_code
        UserNotifier.signup_notification(self).deliver
      end
    end


  included do
    scope :in_state, -> (state) { where(state: state.to_s) }
      validates_presence_of     :login
      validates_length_of       :login,    within: 3..16

      validate do |user|
        valid = if user.new_record?
          not User.find_by_login(user.login)
        else
          not User.where("id <> ? AND login=?", user.id, user.login).select('id').first
        end
        unless valid
          user.errors.add(:login, :taken, value: user.login)
        end
      end

      validates_uniqueness_of   :login
      validates_format_of       :login,    with: Authentication.login_regex#, #login_regex,
        #message: Authentication.bad_login_message

    #  validates_format_of       :name,     with: Authentication.name_regex,
    #    message: Authentication.bad_name_message, allow_nil: true
    #  validates_length_of       :name,     maximum: 100

      validates_presence_of     :email
      validates_length_of       :email,    within: 6..100 #r@a.wk
      validates_uniqueness_of   :email
      validates_format_of       :email,    with: Authentication.email_regex#,
        #message: Authentication.bad_email_message
      before_save :change_to_pending_when_email_change
  end
end
