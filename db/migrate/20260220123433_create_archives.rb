class CreateArchives < ActiveRecord::Migration[7.1]
  def change
    create_table :archives do |t|
      t.string :title
      t.text :description
      t.string :gubernia
      t.integer :year

      t.timestamps
    end
  end
end
