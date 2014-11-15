class DoodleAnswersController < ApplicationController
  unloadable

  menu_item :doodles

  before_filter :find_doodle, only: [:create]
  before_filter :find_doodle_answer, only: [:update]
  before_filter :authorize, :is_doodle_active?

  def create
    @response.answers = Array.new(@doodle.options.size) {|index| (params[:answers] || []).include?(index.to_s)}
    @response.save ? flash[:notice] = l(:doodle_answer_create_successful) : flash[:warning] = l(:doodle_answer_create_unsuccessful)
    redirect_to controller: 'doodles', action: 'show', id: @doodle
  end

  def update
    @response.answers = Array.new(@doodle.options.size) {|index| (params[:answers] || []).include?(index.to_s)}
    @response.save ? flash[:notice] = l(:doodle_answer_update_successful) : flash[:warning] = l(:doodle_answer_update_unsuccessful)
    redirect_to controller: 'doodles', action: 'show', id: @doodle
  end

  private

  def find_doodle
    @doodle = Doodle.find params[:doodle_id], include: [:project, :responses]
    @response = @doodle.responses.new author: User.current
    @project = @doodle.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_doodle_answer
    @response = DoodleAnswers.find params[:id], include: [:author, {doodle: :project}]
    @doodle = @response.doodle
    @project = @doodle.project
  end

  def is_doodle_active?
    unless @doodle.active?
      flash[:error] = l :doodle_inactive
      redirect_to controller: 'doodles', action: 'show', id: @doodle
      return false
    end
    true
  end
end
