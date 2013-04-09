# -*- encoding : utf-8 -*-
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
    update id
  end

  def update_comments_count(id, count=nil)
    count ||= Comment.count :conditions => {:article_id => id, :status => 'publish'}
  end

  def update(id)
    article = Article.find id
    gid = article.group_id
    al = Group.find(gid).inherited_option(:score_algorithm)
    al = 'pos+neg' if al.blank?
    sql = "update articles set score=(#{al}) where id = #{article.id}"
    Article.connection.execute sql
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
