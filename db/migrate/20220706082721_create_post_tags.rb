class CreatePostTags < ActiveRecord::Migration[6.1]
  def change
    create_table :post_tags do |t|
      t.integer :post_id, foreign_key: true
      t.integer :tag_id, foreign_key: true

      t.timestamps
    end

    add_index :post_tags, [:post_id, :tag_id]

  end
end
