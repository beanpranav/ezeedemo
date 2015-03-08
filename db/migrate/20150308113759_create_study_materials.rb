class CreateStudyMaterials < ActiveRecord::Migration
  def change
    create_table :study_materials do |t|
      t.string :name
      t.text :video_source
      t.integer :video_duration
      t.text :model_source
      t.integer :chapter_id

      t.timestamps
    end
  end
end
