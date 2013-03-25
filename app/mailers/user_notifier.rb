# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
class UserNotifier < ActionMailer::Base
  def signup_notification(user)
    @user = user
    @url = url_for :controller=>'users',
      :action => 'activate',
      :activation_code => user.activation_code,
      :only_path => false,
      :host => default_domain    
    mail :to => user.email, 
         :from => Setting.site_email||'admin@test.com', 
         :subject => "[#{Setting.site_name}] 请激活您的帐号"
  end

  def activation(user)
    setup_email(user, '您的帐号已经被成功激活')
    @body[:url] = Setting.site_url
  end

  def fetchpasswd(user, step)
    setup_email(user, "重置密码")
    body body.merge(step == 1 ? {:step => step, :url => "http://#{default_domain}/users/fetchpass/#{user.activation_code}" }:{:step => step})
  end

  def noticemail(user, text, title=nil)
    setup_email_gen( title )
    recipients user.email
    body :username => user.login, :text => text
  end

  def digest_notification(user, articles, comments)
    setup_email user, "您关注的帖子今日有更新"
    body :user => user, :articles => articles, :comments => comments
  end

  def suspend(user)
    setup_email user, "您的帐号已被冻结"
    body :user => user
  end

  def self.digest_notification
    sql = <<SQL
SELECT favorites.*
FROM favorites
INNER JOIN articles ON favorable_id = articles.id AND articles.status = 'publish'
INNER JOIN comments ON articles.id = comments.article_id AND comments.status = 'publish'
WHERE comments.created_at >= ( curdate( ) - INTERVAL 1 DAY )
AND comments.created_at < curdate( ) GROUP BY articles.id
SQL
    @favorites = Favorite.find_by_sql sql
    @favorites = @favorites.group_by(&:user_id)
    @users = User.find_all_by_id @favorites.keys
    sql = <<SQL
SELECT comments.*
FROM comments
WHERE comments.created_at >= ( curdate( ) - INTERVAL 1 DAY )
AND comments.created_at < curdate( ) AND comments.status = 'publish'
SQL
    @comments = Comment.find_by_sql sql
    @comments = @comments.group_by( &:article_id)

    for user in @users
      articles = @favorites[user.id].collect(&:favorable)
      article_ids = articles.collect(&:id)
      puts user.login
      puts article_ids
      comments = {}
      for id in article_ids
        comments[id] = @comments[id]
      end
#      m = UserNotifier.create_digest_notification(user, articles, Hash[*article_ids.zip(@comments.values_at(*article_ids)).to_a.flatten(1)])
      UserNotifier.digest_notification(user, articles, comments).deliver
    end
  end

  def self.resend_password
    User.paginated_each(:conditions => ["state=? and created_at >= ?", 'pending', 30.days.ago]) do |user|
      UserNotifier.fetchpasswd(User.reset_password(:login => user.login, :email => user.email),3).deliver rescue print 'failed:'
      puts user.login
    end
  end
  def invitation_code(user, email, code)
    setup_email(user, "您的朋友'#{user.login}'送给您的邀请码")
    recipients  "#{email}"
    @body[:url]  = "#{code}"
  end

  def invitation_code_anonymous(email,code,article_id)
    from        Setting.site_email
    recipients  "#{email}"
    subject     "[] "
    @subject    += "系统奖励给您的邀请码"
    @body[:url] ="#{code}"
    @body[:article_id]=article_id.to_i
    sent_on     Time.now
  end

  protected
  def setup_email(user, title)
    recipients  user.email
    from        Setting.site_email
    subject     "[#{Setting.site_name}] #{title}"
    sent_on     Time.now
    @user = user
  end

  def setup_email_gen(title)
    from        Setting.site_email
    subject     "[#{Setting.site_name}] #{title}"
    sent_on     Time.now
  end
  protected
  def default_domain
    d = if Setting.default_group
      g = Group.find(Setting.default_group)
      g.domain
    end
    d.blank? ? ActionMailer::Base.default_url_options[:host] : d
  end
end
