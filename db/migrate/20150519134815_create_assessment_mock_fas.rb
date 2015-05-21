class CreateAssessmentMockFas < ActiveRecord::Migration
  def change
    create_table :assessment_mock_fas do |t|
      t.integer :user_id
      t.integer :subject_id
      t.integer :term
      t.integer :attempt
      t.integer :score

      t.timestamps
    end
  end
end
