class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.datetime :published_at
      t.string :title
      t.text :summary
      t.text :content
      t.text :content_html
      t.string :slug
      t.string :type

      t.timestamps
    end

    add_index :posts, :user_id
    add_index :posts, :slug
  end
end
