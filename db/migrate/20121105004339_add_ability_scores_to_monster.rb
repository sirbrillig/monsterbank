class AddAbilityScoresToMonster < ActiveRecord::Migration
  def change
    change_table :monsters do |t|
      [:str, :con, :dex, :int, :wis, :cha].each { |abil| t.integer abil }
    end
  end
end
