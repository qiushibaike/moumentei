# -*- encoding : utf-8 -*-
#!/usr/bin/env ruby
# coding: utf-8

class CommentWorker < BaseWorker
  def vote(opt)
    @comment = Comment.find opt[:comment_id]
    if @comment.article.group_id == 1 or @comment.article.group_id == 3
      if opt[:score] > 0
        @comment.increment :pos
        @comment.increment :score
      else
        @comment.increment :neg
        @comment.decrement :score
      end
      @comment.save!
    else
      return if @comment.user_id == opt[:user_id]
      if @comment.vote opt[:user_id], opt[:score]
        puts "vote comment #{opt.inspect}"
      else
        puts "vote comment fail #{opt.inspect}"
      end
    end
  end
  
  def update_score(comment_id)
    comment = Comment.find comment_id
    article = comment.article
    return unless article.status == 'publish'
    score = article.score
    c = article.comments.public.count
    #if score.public_comments_count != c
    #  score.public_comments_count = c
    #  score.save!
    #end
  end

  # notify comment author when his/her comment is commented by another user
  def notify_comment(comment_id)
    puts "comment parent #{comment_id}"
    comment = Comment.find comment_id

    if comment.parent_id
      parent = Comment.find(comment.parent_id, :include=>[:user,:article])
      puts parent  
      if parent and comment.user_id != parent.user_id
        commented_user= parent.user
        commented_article = parent.article

        if commented_user && commented_article
          
          key="new_comment.#{commented_article.id}.#{comment.user_id}"
          notification = Notification.find_by_key(key)
          puts key
          
          if !notification
            Notification.create :user_id => commented_user.id,
              :key => key,
              :content => "#{commented_article.id}.#{comment.id}"
          else
            Notification.update(notification.id,
              :user_id => commented_user.id,
              :key => key,
              :content => "#{commented_article.id}.#{comment.id}",:read=>false)
          end
        end
      end
    end
  end
  
  # when new comments was left on an article, update those who're watching the
  # article in order that they can saw the comments on their favoriates page
  def notify_watchers(comment_id)
    comment = Comment.find comment_id
    
    article_id = comment.article_id
    favs = Favorite.find_all_by_favorable_id(article_id)
    uid = comment.user_id
    ids = []
    favs.each do |f|
      i = f.user_id
      next if uid == i or i == 0
      ids << i
      f.updated_at = Time.now()
      f.save!
    end
    puts "notify #{ids.join(',')}"
  end

  def number_floor(article_id)
    comments = Comment.find :all,
                :conditions => {
                    :article_id => article_id,
                    :floor => nil,
                    :status => 'publish'}, :order => 'id asc', :lock => true
    comments.each do |c|
      next if c.floor or c.status != 'publish'
      loop do
        begin
          puts "n #{c.id}"
          c.update_attribute :floor,Comment.next_id(article_id)
          break
        rescue ActiveRecord::StatementInvalid => e
          break unless e.message =~ /Duplicate/
        end
      end
    end
  end

  def detect_parent(comment_id)
    comment = Comment.find comment_id
    article = comment.article
    unless comment.parent_id
      if comment.content =~ /(\d+)\s*(l|L|F|f|楼)/
        p = article.comments.find_by_floor $1
        if p
          comment.parent_id = p.id
          comment.save
        end
      end
    end
    comment.content.scan(/(顶|拍)?\s*(\d+)\s*(l|L|F|f|楼)\s*(\+|-)?/).each do |a,floor,c,d|
      s = 1
      if a
        s = -1 if a == '拍'
      elsif d
        s = -1 if d == '-'
      else
        next
      end
      p = article.comments.find :first, :conditions => {:floor => floor} rescue next
      vote(:comment_id => p.id, :score => s, :user_id => comment.user_id)
    end
  end
end
