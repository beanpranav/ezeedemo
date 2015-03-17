class VideoContent < ActiveRecord::Base

	has_attached_file :content
	validates_attachment :content, presence: true, content_type: { content_type: "image/png" } 
	# "video/mp4" }

	validates_presence_of :content_type, :name, :video_duration, :production_date, :producer_name
	
end
