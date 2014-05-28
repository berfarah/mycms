class CreateMeta < ActiveRecord::Migration
  def up
    create_table :meta do |t|
      t.string :key
      t.string :value

      t.references :metable, :polymorphic => true

      t.timestamps
    end
  end

  def down
  	drop_table :meta
  end
end
