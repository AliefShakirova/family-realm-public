class CreatePosts < ActiveRecord::Migration[7.1]

  # Миграция созданной модели Post

  def change
    create_table :posts do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
