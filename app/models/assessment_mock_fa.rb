class AssessmentMockFa < ActiveRecord::Base
		validates_presence_of :user_id, :subject_id, :term, :attempt
		
		belongs_to :user
		belongs_to :subject

		has_many :user_mock_fa_assessment_contents, dependent: :destroy
	  has_many :assessment_contents, through: :user_mock_fa_assessment_contents
end
