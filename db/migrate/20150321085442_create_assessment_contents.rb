class CreateAssessmentContents < ActiveRecord::Migration
  def change
    create_table :assessment_contents do |t|
      t.integer :video_content_id
      t.text :question
      t.text :choice_a
      t.text :choice_b
      t.text :choice_c
      t.text :choice_d
      t.string :answer
      t.string :difficulty_level
      t.string :next_step

      t.timestamps
    end
  end
end
