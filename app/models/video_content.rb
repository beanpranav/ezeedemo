class VideoContent < ActiveRecord::Base
	validates_presence_of :content_type, :name, :content, :video_duration, :production_date
	# , :producer_name

	has_many :study_materials
	has_many :assessment_contents
end
