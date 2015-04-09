class UserStudyProgress < ActiveRecord::Base

	validates_presence_of :user_id, :study_material_id, :rating

	belongs_to :user
	belongs_to :study_material

end
