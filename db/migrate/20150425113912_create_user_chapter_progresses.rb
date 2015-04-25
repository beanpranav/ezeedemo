class CreateUserChapterProgresses < ActiveRecord::Migration
  def change
    create_table :user_chapter_progresses do |t|
      t.integer :user_id
      t.integer :chapter_id
      t.integer :cpi_level
      t.integer :chapter_studied

      t.timestamps
    end
    add_index :user_chapter_progresses, :user_id
  end
end
