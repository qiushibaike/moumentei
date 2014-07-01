# -*- encoding : utf-8 -*-
module Comment::SequenceAspect
  module Noop
    def next_id(article_id)
      max = connection.select_value("SELECT MAX(`floor`) FROM comments WHERE article_id='#{article_id}'").to_i
      max + 1
    end
  end

  module TokyoCabinet
    def next_id(article_id)
      t = Rufus::Tokyo::Cabinet.new( Rails.root.join('db','next_id.tch'))
      i = t.incr article_id
      t.close
      i
    end
  end

  module Mysql
    def next_id(article_id)
      connection.execute "INSERT INTO comment_sequence (`article_id`)VALUES(#{article_id})"
      connection.select_value "SELECT last_insert_id()"
    end
  end

	def number_floor
    return if floor
    #self.floor = self.class.next_id(article_id)
    f = nil
    loop do
      begin
        f = self.class.next_id(article_id)
        self.class.where(id: id).update_all(floor: f)
        break
      rescue ActiveRecord::RecordNotUnique
        false
      end
    end
    self.floor = f
  end

	def self.included(receiver)
		receiver.extend         Noop
		#receiver.send :include, InstanceMethods
    receiver.after_save :number_floor, if: :article
	end
end
