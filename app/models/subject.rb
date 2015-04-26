class Subject < ActiveRecord::Base
	validates_presence_of :name, :board, :standard

	extend FriendlyId
  friendly_id :name_and_board, use: :slugged

  def name_and_board
    "#{board}-#{name}-#{standard}"
  end

  def should_generate_new_friendly_id?
  	name_changed?
  end
	
	has_many :chapters, dependent: :destroy
end
