class CreateWorlds < ActiveRecord::Migration
  def change
    create_table :worlds do |t|
      t.integer :red
      t.integer :green
      t.integer :blue
      t.integer :num_losers
      t.float :mutation_frequency
      t.integer :mutation_size
      
      t.timestamps
    end
  end
end
