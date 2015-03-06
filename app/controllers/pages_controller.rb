class PagesController < ApplicationController
  def home
  	@subjects = Subject.all
  end
end
