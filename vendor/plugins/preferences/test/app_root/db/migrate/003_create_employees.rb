class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string :name, :null => false
      t.string :type
    end
  end
  
  def self.down
    drop_table :employees
  end
end
