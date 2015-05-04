class VideoContentsController < ApplicationController
  before_action :set_video_content, only: [:show, :edit, :update, :destroy]
  before_action :validate_admin

  def index
    @video_contents = VideoContent.all
  end

  def show
  end

  def assessment_admin
    @video_content = VideoContent.find_by(id:params[:id])
    @all_assessments = @video_content.assessment_contents 
    @mcqs = @all_assessments.select { |x| x["content_type"] == "MCQ" }
    @shortqs = @all_assessments.select { |x| x["content_type"] == "ShortQ" }
    @longqs = @all_assessments.select { |x| x["content_type"] == "LongQ" }  
  end

  def new
    @video_content = VideoContent.new
  end

  def edit
  end

  def create
    @video_content = VideoContent.new(video_content_params)

    respond_to do |format|
      if @video_content.save
        format.html { redirect_to @video_content, notice: 'Video content was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @video_content.update(video_content_params)
        format.html { redirect_to @video_content, notice: 'Video content was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @video_content.destroy
    respond_to do |format|
      format.html { redirect_to video_contents_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video_content
      @video_content = VideoContent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_content_params
      params.require(:video_content).permit(:content_type, :name, :content, :video_duration, :production_date, :producer_name, :admin_note)
    end
end
