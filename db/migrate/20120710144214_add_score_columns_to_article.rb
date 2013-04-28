# -*- encoding : utf-8 -*-
class AddScoreColumnsToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :score, :integer, :default => 0
    add_column :articles, :pos, :integer, :default => 0
    add_column :articles, :neg, :integer, :default => 0
  end

  def self.down
    remove_column :articles, :score
    remove_column :articles, :pos
    remove_column :articles, :neg
  end
end
