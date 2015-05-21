class CreateUserMockFaAssessmentContents < ActiveRecord::Migration
  def change
    create_table :user_mock_fa_assessment_contents do |t|
      t.integer :assessment_mock_fa_id
      t.integer :assessment_content_id
      t.string :response

      t.timestamps
    end
  end
end
