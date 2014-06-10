class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user, index: true
      t.datetime :published_at
      t.string :title
      t.text :summary
      t.text :content
      t.string :slug
      t.string :type

      t.timestamps
    end

    add_index :posts, :slug
  end
end
