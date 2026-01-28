class CreateUserProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :user_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.string :maiden_name
      t.date :birth_date
      t.string :place_of_birth
      t.text :description
      t.string :gender

      t.timestamps
    end
  end
end
