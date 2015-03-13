class PagesController < ApplicationController

  def home
  end

  def dashboard
  	@subjects = Subject.all
  end

  def dashboard_parents
  	@subjects = Subject.all
  end

end
