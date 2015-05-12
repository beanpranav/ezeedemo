class TaggedValue < ActiveRecord::Base
	belongs_to :video_contents
	belongs_to :content_tags
end
