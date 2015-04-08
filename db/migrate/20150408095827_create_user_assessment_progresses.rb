class CreateUserAssessmentProgresses < ActiveRecord::Migration
  def change
    create_table :user_assessment_progresses do |t|
      t.integer :user_id
      t.integer :assessment_content_id
      t.string :response

      t.timestamps
    end
    add_index :user_assessment_progresses, :user_id
  end
end
