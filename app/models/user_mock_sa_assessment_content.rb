class UserMockSaAssessmentContent < ActiveRecord::Base

	validates_presence_of :assessment_content_id, :assessment_mock_sa_id

	belongs_to :assessment_content
	belongs_to :assessment_mock_sa

end
