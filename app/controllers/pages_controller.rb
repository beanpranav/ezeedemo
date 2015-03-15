class PagesController < ApplicationController

  def home
  	@subjects = Subject.all

  	def go_to_dashboard
  		redirect_to dashboard_path
  	end

  end

  def common_dashboard
  	@subjects = Subject.all
  end

  def report_card
  	@subjects = Subject.all
  end

end
