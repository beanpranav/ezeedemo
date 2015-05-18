class CreateUserMockSaAssessmentContents < ActiveRecord::Migration
  def change
    create_table :user_mock_sa_assessment_contents do |t|
      t.integer :assessment_mock_sa_id
      t.integer :assessment_content_id
      t.integer :score

      t.timestamps
    end
  end
end
