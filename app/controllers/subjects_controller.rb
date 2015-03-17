class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]

  def index
    @subjects = Subject.all
  end

  def show
  end

  def new
    @subject = Subject.new
  end

  def edit
  end

  def subject_admin
    @subject = Subject.find_by(id:params[:id])
  end

  def create
    @subject = Subject.new(subject_params)

    respond_to do |format|
      if @subject.save
        format.html { redirect_to subjects_url, notice: 'Subject was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to subjects_url, notice: 'Subject was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @subject.destroy
    respond_to do |format|
      format.html { redirect_to subjects_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      params.require(:subject).permit(:name, :board, :standard)
    end
end
