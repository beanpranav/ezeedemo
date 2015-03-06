class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string :name
      t.integer :chapterNumber
      t.integer :term

      t.timestamps
    end
  end
end
