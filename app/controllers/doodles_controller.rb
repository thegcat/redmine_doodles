class DoodlesController < ApplicationController
  unloadable
  before_filter :find_project, :except => [:show, :destroy, :update, :lock, :edit]
  before_filter :find_doodle, :only => [:show, :destroy, :update, :lock, :edit]

  before_filter :authorize

  helper :watchers
  include WatchersHelper

  def index
    @doodles = @project.doodles.reverse
  end

  def new
  end

  def edit
  end

  def show
    @author = @doodle.author
    @responses = @doodle.responses
    @winners = @doodle.winning_columns
    # Give the current user an empty answer if she hasn't answered yet and the doodle is active
    if @doodle.active? && User.current.allowed_to?(:answer_doodles, @project)
      @response = @responses.find_by_author_id(User.current.id)
      @response ||= DoodleAnswers.new :author => User.current
      @response.answers ||= Array.new(@doodle.options.size, false)
      @responses = @responses | [ @response ]
    end
    # Code later needed for comments
    #@comments = @doodle.comments
    #@comments.reverse! if User.current.wants_comments_in_reverse_order?
  end

  def destroy
    @doodle.destroy
    redirect_to :action => 'index', :project_id => @project
  end

  def create
    @doodle.attributes = params[:doodle]
    #@doodle.watcher_user_ids = params[:doodle]['watcher_user_ids']
    @doodle.should_answer_ids = params[:doodle]['should_answer_ids']
    if @doodle.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => 'show', :id => @doodle
    else
      render :action => 'new', :project_id => @project
    end
  end

  def update
    @doodle.attributes = params[:doodle]
    if @doodle.save
      flash[:notice] = l(:doodle_update_successful)
      redirect_to :action => 'show', :id => @doodle
    else
      flash[:warning] = l(:doodle_update_unsuccessful)
      redirect_to :action => 'edit', :id => @doodle
    end
  end

  def lock
    @doodle.update_attribute :locked, params[:locked]
    redirect_to :action => 'show', :id => @doodle
  end

  def preview
    if params[:doodle]
      @doodle = Doodle.new(params[:doodle]).previewfy
      unless @doodle.options.nil? || @doodle.options.empty?
        @winners = []
        @responses = [DoodleAnswers.new(:author => User.current, :answers => Array.new(@doodle.options.size, false))]
      end
      render :layout => false
    end
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
    @doodle = Doodle.new(:project => @project, :author => User.current)
  end

  def find_doodle
    @doodle = Doodle.find(params[:id], :include => [:project, :author, :responses, :should_answer])
    @project = @doodle.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
