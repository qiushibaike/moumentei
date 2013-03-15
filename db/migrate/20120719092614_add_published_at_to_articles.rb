class AddPublishedAtToArticles < ActiveRecord::Migration
  def self.up
  	add_column :articles, :published_at, :datetime
  	add_index :articles, [:group_id, :status, :published_at, :score]
  	execute <<sql
  	update articles, scores 
  		set articles.published_at = scores.created_at 
  		where 
  			articles.id = scores.article_id 
  			and articles.status = 'publish' 
  			and articles.published_at is null
sql
    execute 'update articles set published_at = created_at where published_at is null and status = "publish"'
  end

  def self.down
  	remove_column :articles, :published_at
  end
end
