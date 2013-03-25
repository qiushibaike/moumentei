# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
class Comment < ActiveRecord::Base
  include AntiSpam
  harmonize :content
  include SequenceAspect
  belongs_to :article, :touch => true
  belongs_to :user
  has_many :ratings, :class_name => 'CommentRating', :dependent => :delete_all
  has_many :reports ,:as => :target
  scope :today, lambda {{:conditions => {:created_at => Date.today}}}
  scope :public, :conditions => {:status => ['publish', 'private']}
  scope :anonymous, :conditions => {:anonymous => true}
  scope :signed, :conditions => {:anonymous => false}
  scope :by_status, lambda {|status| {:conditions => {:status => status}}}
  attr_protected :user_id, :status
  after_save :create_notification
  #validates_length_of :content, :minimum => 1
  #after_save :update_score
  after_create :comment_notify

  STATUSES = %w(publish pending spam private deleted)

  #the number of new comments in the day given
  def self.all_number(date)
    from=date.to_time
    to  =(date+1).to_time
    comments=Comment.find :all, :conditions => ["created_at > ? and created_at < ? ",from,to ]
    number=comments.length
    number
  end

  def after_initialize
    if new_record?
      self.pos = 0
      self.neg = 0
      self.score = 0
    else
      self.pos ||= ratings.pos.count.to_i
      self.neg ||= ratings.neg.count.to_i
      self.score ||= pos.to_i - neg.to_i
    end
  end

  def vote user_id, s
    return false if self.user_id == user_id
    transaction do
      lock!
      r = ratings.find_by_user_id user_id, :lock => true

      if r
        if r.score != s
          if r.score > 0
            decrement :pos
          else
            decrement :neg
          end
          decrement :score, r.score
          r.score = s
          r.save!
        else
          return false
        end
      else
        CommentRating.create :comment_id => id,
          :user_id => user_id,
          :score => s
      end

      if s > 0
        increment :pos
        increment :score
      else
        increment :neg
        decrement :score
      end
      save
    end
  rescue ActiveRecord::StatementInvalid => e
    if e.message.index('Duplicate')
     return false
    else
     raise e
    end
  end

  def public?
    status == 'publish'
  end

  #  attr_accessor :pos_score, :neg_score
#  alias_method :pos_score, :pos
#  alias_method :neg_score, :neg
#  alias_method :pos_score=, :pos=
#  alias_method :neg_score=, :neg=

  def total_score
    score || 0 #pos - neg
  end

  def rated_by? user
    uid = user.is_a?(User) ? user.id : user
    return true if uid == user_id
    CommentRating.find :first, :conditions => {:user_id => uid, :comment_id => id}, :select => 'id'
  end

  def ip
    @string_ip ||= long2ip(self['ip'])
  end

  def ip= ip
    if ip.is_a?(String)
      self['ip'] = ip2long(ip)
      @string_ip = ip
    else
      self['ip'] = ip.to_i
      @string_ip = long2ip(ip.to_i)
    end
  end

  def self.archive
    p = lambda do |s1, s2|
      where = "FROM `#{table_name}` WHERE status = '#{s1}' and created_at < CURDATE() - INTERVAL 7 DAY"
      connection.execute "INSERT INTO `#{table_name}_#{s2}` SELECT * #{where}"
      connection.execute "DELETE #{where}"
    end
    p.call 'spam', 'spam'
    p.call 'private', 'deleted'
  end

  def self.load_ratings(*args)
  end

  def rated? user, comment_ids
    user_id = user.is_a?(User) ? user.id : user
    result ={}
    CommentRating.find(:all,
      :conditions => {:user_id => user_id, :comment_id=>comment_ids},
      :select => [:comment_id]).each do |r|
      result[r.comment_id] = true
    end
  end
  def anonymous?
    anonymous || !user || user.deleted?
  end
  def as_json(opt={})
    except = [:ip]
    except << :user_id if anonymous?
    super(:except=>except)
  end

  protected
  def comment_notify
    CommentWorker.async_notify_watchers id if status == 'publish'
  end

  def create_notification
    if attribute_present?(:status) and status=='publish'
      if attribute_present?(:parent_id) and parent_id
        CommentWorker.async_notify_comment id
      else
        CommentWorker.async_detect_parent id
      end
    end
    CommentWorker.async_update_score id
  end
end
