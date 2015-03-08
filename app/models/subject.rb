class Subject < ActiveRecord::Base
	validates_presence_of :name
	
	has_many :chapters, dependent: :destroy
end
