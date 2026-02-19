class AddLocationNameToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :location_name, :string

    change_column_null :events, :location_id, true
  end
end
