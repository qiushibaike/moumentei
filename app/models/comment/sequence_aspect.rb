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
	module ClassMethods
    #include Mysql
    include Noop
    def create_sequences
      Article.paginated_each(:per_page => 10000,
        :conditions => {:status => 'publish'},
        :select => 'id') do |a|
        #t[a.id] = a.public_comments_count
        comments = Comment.find :all,
                  :conditions => {
                      :article_id => a.id}, :order => 'id asc', :select => 'id, article_id, floor', :lock => true
        i=0
        comments.each do |c|
          i+=1
          c.update_attribute :floor, i
        end
      end
      #t.close
    end
    def fill_floor!
      loop do
      recs = find(:all, :conditions => 'article_id is not null and floor is null', :limit => 10000, :order => 'id asc')
      break if recs.size == 0
      recs.each do |p|
        p.send :number_floor
      end
      end
    end
	end

	#module InstanceMethods

	#end
	def number_floor
    return if floor
    #self.floor = self.class.next_id(article_id)
    f = nil
    loop do
      begin
        f = self.class.next_id(article_id)
        self.class.update_all({:floor => f}, {:id => id})
        break
      rescue ActiveRecord::StatementInvalid => e
        raise e unless e.message =~ /Duplicate/
      end
    end
    self.floor = f
  end
	def self.included(receiver)
		receiver.extend         ClassMethods
		#receiver.send :include, InstanceMethods
    receiver.after_save :number_floor, :if => :article
	end
end
