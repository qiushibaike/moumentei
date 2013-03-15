#!/usr/bin/env ruby
# coding: utf-8
class ScoreWorker < BaseWorker
  def vote(options)
    action = options[:action]
    id = options[:id]
    puts "#{action}, #{id}"
    case action
    when :up
      query = "UPDATE scores SET pos=pos+1 WHERE article_id=#{id}"
    when :down
      query = "UPDATE scores SET neg=neg-1 WHERE article_id=#{id}"
    end
    Score.connection.execute query
    update id
  end

  def update_comments_count(id, count=nil)
    count ||= Comment.count :conditions => {:article_id => id, :status => 'publish'}
    Score.update_all({:public_comments_count => count}, {:article_id => id})
  end

  def update(id)
    article = Article.find id
    gid = article.group_id
    al = Group.find(gid).inherited_option(:score_algorithm)
    al = 'pos+neg' if al.blank?
    sql = "update articles set score=(#{al}) where id = #{article.id}"
    Article.connection.execute sql
    #@ids ||= {}
    #@ids[gid] ||= Set.new
    #@ids[gid] << id
    #@timer ||= EM.add_timer 5*60, method(:bulkupdate)
    #puts @ids.inspect
    #bulkupdate if @ids[gid].size >= 7
  end

  def bulkupdate
    @ids.each do |gid, s|
      next if s.size == 0
      al = Group.find(gid).inherited_option(:score_algorithm)
      al = 'pos' if al.blank?
      sql = "update scores set score=(#{al}) where article_id in (#{s.to_a.join(',')})"
      puts "---#{gid}---"
      puts sql
      Score.connection.execute sql
      s.clear
    end
    #@timer = nil
  end
end
