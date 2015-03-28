class CreateAssessmentImages < ActiveRecord::Migration
  def change
    create_table :assessment_images do |t|
      t.integer :assessment_content_id
      t.string :image_type

      t.timestamps
    end
    add_index :assessment_images, :assessment_content_id
  end
end
