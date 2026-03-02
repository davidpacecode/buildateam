class CreatePlayers < ActiveRecord::Migration[8.1]
  def change
    create_table :players do |t|
      t.integer :overall_rank
      t.string :first_name
      t.string :last_name
      t.string :position
      t.string :height
      t.string :team
      t.integer :overall
      t.integer :three_pt
      t.integer :dunk

      t.timestamps
    end
  end
end
