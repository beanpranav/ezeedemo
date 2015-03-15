class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name, :phone_number

  def first_name
  	name.split(" ")[0]
  end

  def last_name
  	name.split(" ")[1]
  end

end
