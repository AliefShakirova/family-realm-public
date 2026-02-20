class CreateTimelineEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :timeline_events do |t|
      t.string :title
      t.date :event_date
      t.text :description
      t.integer :group_id
      t.integer :ancestor_id

      t.timestamps
    end
  end
end
