class AddParentsToAncestors < ActiveRecord::Migration[7.1]
  def change
    add_column :ancestors, :father_id, :integer
    add_column :ancestors, :mother_id, :integer
  end
end
