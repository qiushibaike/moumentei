# -*- encoding : utf-8 -*-
class CreateMetadatas < ActiveRecord::Migration
  def self.up
    create_table :metadatas do |t|
      t.integer :article_id
      t.string :key
      t.text :value

      t.timestamps
    end
    add_index :metadatas, [:article_id, :key], :unique => true
  end

  def self.down
    drop_table :metadatas
  end
end
