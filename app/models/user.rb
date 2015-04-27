class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name, :phone_number

  has_many :user_study_progresses, dependent: :destroy
  has_many :study_materials, through: :user_study_progresses

  has_many :user_assessment_progresses, dependent: :destroy
  has_many :assessment_contents, through: :user_assessment_progresses

  has_many :user_chapter_progresses, dependent: :destroy
  has_many :chapters, through: :user_chapter_progresses

  def first_name
  	name.split(" ")[0]
  end

  def last_name
  	name.split(" ").last
  end
  
end
