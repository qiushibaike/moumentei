# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
# The article model
class Article < ActiveRecord::Base
  include AntiSpam
  harmonize :title, :content, :tag_line
  include ReferenceAspect
  include ScoreAspect
  include TicketAspect
  include CommentAspect
  include PictureAspect
  include Navigation
  include MetadataAspect
  include PublishCallbacksAspect
  #meta_field :original_url
  acts_as_taggable
  acts_as_favorite
  
  before_save do |rec|
    rec.tag_list = rec.tag_line if rec.tag_line_changed?
    rec.status = 'future' if rec.status == 'publish' and rec.created_at and rec.created_at_changed? and rec.created_at > Time.now + 5.minutes
  end

  before_publish do |rec|
    rec.published_at ||= Time.now 
  end
  
  #acts_as_archive unless RUBY_PLATFORM =~ /win32|mingw/
  # the status enum
  STATUSES = %w(publish private pending spam deleted future)
  validates_inclusion_of :status,  :in => STATUSES.collect(&:to_s)
  has_many :reports ,:as => :target
  has_many :ratings,  :dependent => :delete_all
  has_many :anonymous_ratings, :dependent => :delete_all
  belongs_to :original_picture, :class_name => 'Picture', :foreign_key => 'picture_id'
  belongs_to :group
  validates_presence_of :group
  belongs_to :user
  validates_presence_of :user, :unless => :anonymous
  scope :by_status, lambda {|status| {:conditions => {:status => status}}}
  scope :by_period, lambda {|s, e| {:conditions => ['articles.created_at >= ? and articles.created_at < ?', s, e]}}
  scope :by_group, lambda {|group_id| {:conditions => {:group_id => group_id}}}
  scope :public, :conditions => {:status => 'publish'}
  scope :anonymous, :conditions => {:anonymous => true}
  scope :signed, :conditions => {:anonymous => false}
  scope :pending, :conditions => {:status => 'pending'}
  scope :hottest, :order => 'score desc'
  scope :latest, :order => 'published_at desc'
  scope :published_after, lambda{|time| where{published_at >= time} }
  attr_protected :user_id, :status

  cattr_accessor :per_page
  @@per_page = 20

  def anonymous?
    anonymous or user_id == 0 or !user_id or user.blank?
  end

  def public?
    status == 'publish'
  end

  class << self
    # top n article with specified items
    def top n, options = {}
      cond = [[]]
      if options[:status]
        cond[0] << 'articles.status = ?'
        cond << 'publish'
      end
      if options[:group]
        options[:group] = options[:group].id if options[:group].is_a? Group
        cond[0] << 'scores.group_id = ?'
        cond << options[:group]
      end

      if options.has_key? :in
        cond[0] << 'scores.created_at >= ?'
        cond << (Time.now - options[:in]).to_date
      end
      cond[0] = cond[0].join(' AND ')
      find :all,
        :conditions => sanitize_sql(cond),
        :order => 'scores.score DESC',
        :include => :score,
        :limit => n
    end

    def ids_in(time)
      with_scope do
        public.all(:select => 'articles.id',
          :conditions => ["created_at > ?",( Time.now - time).to_date]).collect{|a|a.id}
      end
    end

    def cached_tag_clouds
      Tag
      c = Rails.cache.fetch('tag_clouds', :expires_in => 86400) do
        tag_counts( :limit    => 100,
                    :at_least => 5,
                    :order    => 'count DESC').sort_by{rand}
      end
      if c.size == 0
        Rails.cache.delete 'tag_clouds'
        Rails.cache.delete "views/tag_cloud"
        Rails.cache.delete 'views/tag_cloud_homepage'
      end
      c
    end

    def recent_hot(page)
      where{alt_score > 0}.paginate :page => page, :order => 'alt_score desc',:include => [:user]
    end

    def pictures(group_id, page)
      with_scope do
        s = Score.paginate(:page => page, :conditions=>{:has_picture=>1, :group_id => group_id},:order => 'created_at desc')
        scores_to_articles(s)
      end
    end

    protected
      # find corresponding article records according to the scores records
      # from the database, and then combine the two dataset together into a
      # new articles dataset

  end

  def ip
    @string_ip ||= long2ip(self['ip'])
    return @string_ip
  end

  def ip= ip
    if ip.is_a?(String)
      self['ip'] = ip2long(ip)
      @string_ip = ip
    else
      self['ip'] = ip.to_i
      @string_ip = nil
    end
  end

  def publish!
    self.status = 'publish'
    save if changed?
  end

  def reject!(reason=nil)
    self.status = 'private'
    save if changed?
  end

  def move_to(g)
  transaction do
    self.group_id = g.id
    score.group_id = g.id
    score.save!
    save!
  end
  end

  def as_json(opt={})
    a = self
    sign = !a.anonymous && a.user_id && a.user_id > 0 && a.user
    b = sign ?
      ['anonymous', 'status', 'ip'] :
      ['user_id', 'anonymous', 'status', 'ip']

    j = super(
      :except => b
    ).merge(
      score.as_json(:except => ['group_id', 'created_at', 'id', 'article_id'])
    )
    if sign
      u = {
        'login' => user.login,
        'avatar' => user.avatar.url,
      }
      j['user'] = u
    end
    j
  end

  def self.clear_cache
    paginated_each(:conditions => 'updated_at >= now() - interval 5 minute', :per_page => 1000) do |article|
      group =  article.group
      domain = article.group.domain
      theme = group.inherited_option(:theme)
      article_id = article.id
      [theme, "#{theme}_wap"].each do |t|
        p = Rails.root.join 'public', "cache/GET/#{t}/articles/#{article_id}/comments.html"
        File.delete p if File.exists?(p)
        p = Rails.root.join 'public', "cache/GET/#{t}/articles/#{article_id}.htm"
        File.delete p if File.exists?(p)
        Rails.cache.delete("#{domain}/#{t}/articles/#{article_id}/comments.html")
        Rails.cache.delete("#{domain}/#{t}/articles/#{article_id}/comments.mobile")
        Rails.cache.delete("#{domain}/#{t}/articles/#{article_id}.htm")
        Rails.cache.delete("#{domain}/#{t}/articles/#{article_id}.mobile")
      end
    end
  end
  protected

  # create a score record when an article is created

end
