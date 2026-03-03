class CreateTeams < ActiveRecord::Migration[8.1]
  def change
    create_table :teams do |t|
      t.integer :pg_id
      t.integer :sg_id
      t.integer :sf_id
      t.integer :pf_id
      t.integer :c_id
      t.string :session_token
      t.string :ip_address

      t.timestamps
    end

    add_index :teams, :pg_id
    add_index :teams, :sg_id
    add_index :teams, :sf_id
    add_index :teams, :pf_id
    add_index :teams, :c_id
    add_index :teams, :session_token
    add_index :teams, :ip_address
  end
end
