class VideoContent < ActiveRecord::Base
	validates_presence_of :content_type, :name, :content, :video_duration, :production_date
	# , :producer_name

	has_many :study_materials
	has_many :assessment_contents

	has_many :tagged_values, dependent: :destroy
  has_many :content_tags, through: :tagged_values
end
