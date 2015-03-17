class CreateVideoContents < ActiveRecord::Migration
  def change
    create_table :video_contents do |t|
      t.string :content_type
      t.string :name
      t.integer :video_duration
      t.date :production_date
      t.string :producer_name
      t.string :admin_note

      t.timestamps
    end
  end
end
