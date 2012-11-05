class AddHighAbilityToMonster < ActiveRecord::Migration
  def change
    add_column :monsters, :high_ability, :string
  end
end
