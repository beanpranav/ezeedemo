class Subject < ActiveRecord::Base
	validates_presence_of :name, :board, :standard
	
	has_many :chapters, dependent: :destroy
end
