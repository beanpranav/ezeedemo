class AddSubjectIdToChapter < ActiveRecord::Migration
  def change
    add_column :chapters, :subject_id, :integer
    add_index :chapters, :subject_id
    add_column :chapters, :slug, :string
    add_index :chapters, :slug, unique: true
  end
end
