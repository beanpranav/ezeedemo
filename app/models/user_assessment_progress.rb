class UserAssessmentProgress < ActiveRecord::Base

	belongs_to :user
	belongs_to :assessment_content

end
