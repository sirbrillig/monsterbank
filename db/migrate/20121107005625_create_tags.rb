class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end

    create_table :monsters_tags, :id => false do |t|
      t.references :monster, :tag
#       t.integer :tag_id
#       t.integer :monster_id
    end

    add_index :monsters_tags, [:monster_id, :tag_id]
  end
end
