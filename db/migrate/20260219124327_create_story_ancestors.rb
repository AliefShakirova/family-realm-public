class CreateStoryAncestors < ActiveRecord::Migration[7.1]
  def change
    create_table :story_ancestors do |t|
      t.references :story, null: false, foreign_key: true
      t.references :ancestor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
