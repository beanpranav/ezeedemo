class CreateAssessmentMockSas < ActiveRecord::Migration
  def change
    create_table :assessment_mock_sas do |t|
      t.integer :user_id
      t.integer :subject_id
      t.string :term
      t.integer :attempt
      t.integer :score

      t.timestamps
    end
  end
end
