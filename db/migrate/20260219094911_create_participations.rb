class CreateParticipations < ActiveRecord::Migration[7.1]
  def change
    create_table :participations do |t|
      t.references :event, null: false, foreign_key: true
      t.references :ancestor, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
