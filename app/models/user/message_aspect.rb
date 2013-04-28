# -*- encoding : utf-8 -*-
class User
  module MessageAspect
    def self.included(base)
      #ap base
      base.has_many :messages, :foreign_key => 'owner_id'
    end
    def inbox_messages
      messages.find :all, :conditions => ["sender_id <> ?", self.id], :order => 'id desc'
    end

    def inbox_messages_by_page(page)
      messages.paginate :page => page, :conditions => ["sender_id <> ?", self.id], :order => 'id desc'
    end

    def outbox_messages
      messages.find :all, :conditions => {:sender_id => self.id}, :order => 'id desc'
    end

    def outbox_messages_by_page(page)
      messages.paginate :page => page, :conditions => {:sender_id => self.id}, :order => 'id desc'
    end

    def unread_messages_count
      @unread_messages_count ||= messages.unread.count
    end
  end
end
