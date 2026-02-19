class AddStoryDateToStories < ActiveRecord::Migration[7.1]
  def change
    add_column :stories, :story_date, :date
  end
end
