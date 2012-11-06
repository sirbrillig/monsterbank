class AddStarredToMonster < ActiveRecord::Migration
  def change
    add_column :monsters, :starred, :boolean
  end
end
