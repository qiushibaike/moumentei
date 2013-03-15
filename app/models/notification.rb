class Notification < ActiveRecord::Base
  belongs_to :user
  named_scope :unread, :conditions => {:read => false}

  serialize :content

  def key
    @key ||= self['key'].split(/\./)
  end
   def content
    @content ||= self['content'].split(/\./)
  end

  def read!
    self.read = true
    save!
  end
end
