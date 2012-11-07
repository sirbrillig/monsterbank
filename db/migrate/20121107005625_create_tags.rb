class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end

    create_table :monsters_tags, :id => false do |t|
      t.integer :tag_id
      t.integer :monster_id
    end
  end
end
