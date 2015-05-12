class CreateTaggedValues < ActiveRecord::Migration
  def change
    create_table :tagged_values do |t|
      t.integer :content_tag_id
      t.integer :video_content_id

      t.timestamps
    end
  end
end
