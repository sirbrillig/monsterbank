class AddSpeedToMonster < ActiveRecord::Migration
  def change
    change_table :monsters do |t|
      t.string :speed
    end
  end
end
