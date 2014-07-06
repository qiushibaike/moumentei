# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
# The article model
class Article < ActiveRecord::Base
  DAY = { # TODO: move to i18n
    '8hr' => '8小时',
    "day" => "24小时",
    "week" => "7天",
    "month" => "30天" ,
    "year"=>"365天",
    "all" => "有史以来" }

  KEYS = ['8hr', "day", "week", "month", "year", "all"]

  DateRanges = {
    '8hr' => 8.hour,
    'day' => 1.day,
    'week' => 1.week,
    'month' => 1.month,
    'year' => 1.year
  }
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
  validates_inclusion_of :status,  in: STATUSES.collect(&:to_s)
  has_many :reports ,as: :target
  has_many :ratings,  dependent: :delete_all
  has_many :anonymous_ratings, dependent: :delete_all
  belongs_to :original_picture, class_name: 'Picture', foreign_key: 'picture_id'
  belongs_to :group
  validates_presence_of :group
  belongs_to :user
  validates_presence_of :user, unless: :anonymous
  scope :by_status, -> (status) { where(status: status)}
  scope :by_period, ->(s, e) { where ['articles.created_at >= ? and articles.created_at < ?', s, e]}
  scope :by_group, ->(group_id) { where group_id: group_id }
  scope :public, -> { where(status: 'publish') }
  scope :anonymous, -> { where(anonymous: true) }
  scope :signed, -> { where(anonymous: false) }
  scope :pending, -> { where(status: 'pending') }
  scope :hottest, -> { order('score desc') }
  scope :hottest_by, -> (period=nil) { DateRanges.include?(period) ? hottest.where{ created_at >= DateRanges[period].ago } : hottest }
  scope :latest, -> { order('published_at desc') }
  scope :published_after, ->(time) { where{published_at >= time} }
  scope :recent_hot, -> { where{alt_score > 0}.order('alt_score desc') }
  attr_protected :user_id, :status

  cattr_accessor :per_page
  @@per_page = 20

  def anonymous?
    anonymous or user_id == 0 or !user_id or user.blank?
  end

  def public?
    status == 'publish'
  end

  def ip= ip
    if ip.is_a?(String)
      self['ip'] = IPUtils.ip2long(ip)
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

  protected

  # create a score record when an article is created

end
