class CreateCars < ActiveRecord::Migration
  def self.up
    create_table :cars do |t|
      t.string :name, :null => false
    end
  end
  
  def self.down
    drop_table :cars
  end
end
