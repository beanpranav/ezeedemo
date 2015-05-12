class ContentTag < ActiveRecord::Base
	validates_presence_of :tag_name, :tag_type

	has_many :tagged_values, dependent: :destroy
  has_many :video_contents, through: :tagged_values
end
