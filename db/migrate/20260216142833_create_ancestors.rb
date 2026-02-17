class CreateAncestors < ActiveRecord::Migration[7.1]
  def change
    create_table :ancestors do |t|
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.date :birth_date
      t.date :death_date
      t.string :birth_place
      t.text :description
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
