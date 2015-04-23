class UserAssessmentProgress < ActiveRecord::Base

	validates_presence_of :user_id, :assessment_content_id, :response

	belongs_to :user
	belongs_to :assessment_content

end
