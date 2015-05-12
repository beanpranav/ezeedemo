class CreateContentTags < ActiveRecord::Migration
  def change
    create_table :content_tags do |t|
      t.text :tag_name
      t.string :tag_type

      t.timestamps
    end

    add_index :content_tags, :tag_name, unique: true
  end
end
