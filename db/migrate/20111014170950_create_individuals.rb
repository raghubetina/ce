class CreateIndividuals < ActiveRecord::Migration
  def change
    create_table :individuals do |t|
      t.integer :red
      t.integer :green
      t.integer :blue
      t.float :score
      t.integer :alive
      
      t.timestamps
    end
  end
end
