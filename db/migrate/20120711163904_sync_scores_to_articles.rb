class SyncScoresToArticles < ActiveRecord::Migration
  def self.up
    execute 'UPDATE articles, scores SET articles.pos=scores.pos, articles.neg=scores.neg, articles.score=scores.score WHERE articles.id = scores.article_id' 
  end

  def self.down
  end
end
