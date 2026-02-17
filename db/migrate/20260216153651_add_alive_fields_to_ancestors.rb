class AddAliveFieldsToAncestors < ActiveRecord::Migration[7.1]
  def change
    add_column :ancestors, :alive, :boolean
    add_column :ancestors, :phone, :string
    add_column :ancestors, :current_address, :string
    add_column :ancestors, :death_place, :string
  end
end
