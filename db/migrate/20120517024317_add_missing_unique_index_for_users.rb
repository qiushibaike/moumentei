class AddMissingUniqueIndexForUsers < ActiveRecord::Migration
  def self.up
    remove_index :users, :login
    remove_index :users, :email
    add_index :users, :login, :unique => true
    add_index :users, :email, :unique => true
  end

  def self.down
  end
end
