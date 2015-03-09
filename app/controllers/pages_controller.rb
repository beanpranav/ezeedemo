class PagesController < ApplicationController

  def home
  end

  def dashboard
  	@subjects = Subject.all
  end

end
