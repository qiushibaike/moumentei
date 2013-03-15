# the Score model or scores table is actually a statistical table for caching
# some numbers of articles
# because of rapidly ratings, the table will use innodb engine 
# for concurrent insert and modify
class Score < ActiveRecord::Base
  set_primary_key :article_id
  belongs_to :article
  cattr_accessor :per_page
  @@per_page = 20
  
  after_update do |rec|
    ScoreWorker.async_update rec.article_id
  end
  
  def self.rebuild
    id = ENV['article_id'].to_i || 0
    groups = {}
    group_ids = {}
    
    Group.find(:all).each do |g|
      groups[g.id] = g.inherited_option(:score_algorithm)
      groups[g.id] = 'pos+neg' if groups[g.id].blank?
      group_ids[g.id] = []
    end

    loop do
      puts id
      scores = find :all, :conditions => ['article_id >= ?', id], :limit => 1000, :order => 'article_id asc'
      return if scores.size == 0
      id += 1000
      scores.each do |s|
        begin
#          ap s
          
          art = Article.find s.article_id, :select => [:id]
          s.public_comments_count = art.comments.public.count
          s.pos = art.ratings.pos.count + art.anonymous_ratings.pos.count
          s.neg = -(art.ratings.pos.count + art.anonymous_ratings.neg.count)
          s.ratings_count = s.pos + s.neg
          s.save
          group_ids[s.group_id] << s.article_id
          id = s.article_id if s.article_id > id
          print '.'
        rescue ActiveRecord::RecordNotFound
          Score.delete_all :article_id => s.article_id
          print 'x'
        end
      end
      group_ids.each do |key, ids|
        next if ids.size == 0
        sql = "update scores set score=(#{groups[key]}) where article_id in (#{ids.to_a.join(',')})"
        puts sql
        Score.connection.execute sql
        group_ids[key].clear
      end      
    end
  end
end
