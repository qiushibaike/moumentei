# -*- encoding : utf-8 -*-
class AddPublishedAtToArticles < ActiveRecord::Migration
  def self.up
  	add_column :articles, :published_at, :datetime
  	add_index :articles, [:group_id, :status, :published_at, :score]
  end

  def self.down
  	remove_column :articles, :published_at
  end
end
