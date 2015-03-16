class PagesController < ApplicationController

  def home
  	@subjects = Subject.where(standard: 10)
  end

  def common_dashboard
  	@subjects = Subject.where(standard: 10)
  end

  def report_card
  	@subjects = Subject.where(standard: 10)
  end

end
