class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]

  def index
    @subjects = Subject.all
  end

  def show
    @chapters_all = @subject.chapters.sort_by(&:chapterNumber)
    @chapters_term_1 = @chapters_all.select { |x| x["term"] == 1 }
    @chapters_term_2 = @chapters_all.select { |x| x["term"] == 2 }

    @goals_term_1 = 0
    @chapters_term_1.each do |chapter|
      @goals_term_1 += chapter.study_materials.count
    end

    @goals_term_2 = 0
    @chapters_term_2.each do |chapter|
      @goals_term_2 += chapter.study_materials.count
    end

  end

  def new
    @subject = Subject.new
  end

  def edit
  end

  def subject_admin
    @subject = Subject.find_by(id:params[:id])
    @chapters_term_1 = @subject.chapters.select { |x| x["term"] == 1 }
    @chapters_term_2 = @subject.chapters.select { |x| x["term"] == 2 }
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
