# -*- encoding : utf-8 -*-
class AddAltScoreToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :alt_score, :integer , :default => 0
    add_index :articles, [:group_id, :status, :alt_score]
  end

  def self.down
    remove_column :articles, :alt_score
  end
end
