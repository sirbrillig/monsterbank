class AddMonstersToUsers < ActiveRecord::Migration
  def change
    add_column :monsters, :user_id, :integer
  end
end
