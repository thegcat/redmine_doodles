class DoodlesController < ApplicationController
  unloadable
  
  before_filter :find_project, :except => [:show, :destroy, :update, :lock, :comment]
  before_filter :find_doodle, :only => [:show, :destroy, :update, :lock, :comment]
  before_filter :doodle_active?, :only => [:update, :comment]
  before_filter :authorize
  
  verify :method => :post, :only => [:lock, :comment], :redirect_to => { :action => :show }
  
  helper :watchers
  include WatchersHelper
  
  def index
    @doodles = @project.doodles.reverse
  end

  def new
    @doodle = Doodle.new(:project => @project)
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
    @comments = @doodle.comments
    @comments.reverse! if User.current.wants_comments_in_reverse_order?
  end

  def destroy
  end
  
  def create
    @doodle = Doodle.new(:project => @project, :author => User.current)
    @doodle.attributes = params[:doodle]
    if @doodle.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => 'show', :id => @doodle
    else
      render :action => 'new', :project_id => @project
    end
  end
  
  def update
    params[:answers] ||= []
    @answers = Array.new(@doodle.options.size) { |index| params[:answers].include?(index.to_s) }
    @response = @doodle.responses.find_or_initialize_by_author_id(User.current.id)
    @response.answers = @answers
    if @response.save
      flash[:notice] = l(:doodle_update_successfull)
      redirect_to :action => 'show', :id => @doodle
    else
      flash[:warning] = l(:doodle_update_unseccessfull)
      redirect_to :action => 'show', :id => @doodle
    end
  end
  
  def comment
    @comment = Comment.new(params[:comment])
    @comment.author = User.current
    if @doodle.comments << @comment
      flash[:notice] = l(:label_comment_added)
      redirect_to :action => 'show', :id => @doodle
    # TODO: handle failed comments
    #else
    #  show
    #  render :action => 'show'
    end
  end
  
  def lock
    @doodle.update_attribute :locked, params[:locked]
    redirect_to :action => 'show', :id => @doodle
  end
  
  def preview
    if params[:doodle]
      @doodle = Doodle.new(params[:doodle]).previewfy
      unless @doodle.options.empty?
        @winners = []
        @responses = [DoodleAnswers.new(:author => User.current, :answers => Array.new(@doodle.options.size, false))]
      end
      render :layout => false
    end
  end
  
  private
  
  def find_project
    @project = Project.find(params[:project_id])
  end
  
  def find_doodle
    @doodle = Doodle.find(params[:id], :include => [:project, :author, :responses])
    @project = @doodle.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end
  
  def doodle_active?
    unless @doodle.active?
      flash[:error] = l(:doodle_inactive)
      redirect_to :action => 'show', :id => @doodle
      return
    end
  end
end
