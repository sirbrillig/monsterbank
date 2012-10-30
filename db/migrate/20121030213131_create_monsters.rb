class CreateMonsters < ActiveRecord::Migration
  def change
    create_table :monsters do |t|
      t.string :name
      t.integer :level
      t.string :role
      t.string :subrole

      t.timestamps
    end
  end
end
