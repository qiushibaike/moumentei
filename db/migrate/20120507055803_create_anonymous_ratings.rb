# -*- encoding : utf-8 -*-
class CreateAnonymousRatings < ActiveRecord::Migration
  def self.up
    create_table :anonymous_ratings do |t|
      t.integer :ip,:null => false
      t.integer :article_id,:null => false
      t.integer :score, :default => 1
      #t.timestamps
    end
    add_index :anonymous_ratings, [:ip, :article_id], :unique => true 
  end

  def self.down
    drop_table :anonymous_ratings
  end
end
