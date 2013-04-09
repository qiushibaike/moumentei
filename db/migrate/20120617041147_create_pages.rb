# -*- encoding : utf-8 -*-
class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :group_id
      t.string :title
      t.text :content
      t.integer :user_id
      t.integer :parent_id
      t.string :slug
      t.string :path

      t.timestamps
    end
    add_index :pages, :user_id
    add_index :pages, [:group_id, :parent_id]
    add_index :pages, :path
  end

  def self.down
    drop_table :pages
  end
end
