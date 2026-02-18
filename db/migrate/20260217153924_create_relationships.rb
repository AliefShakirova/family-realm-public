class CreateRelationships < ActiveRecord::Migration[7.1]
  def change
    create_table :relationships do |t|
      t.references :group, null: false, foreign_key: true
      t.references :ancestor, null: false, foreign_key: { to_table: :ancestors }
      t.references :relative, null: false, foreign_key: { to_table: :ancestors }
      t.string :relation_type

      t.timestamps
    end
  end
end
