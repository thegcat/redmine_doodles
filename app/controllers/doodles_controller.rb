class DoodlesController < ApplicationController
  unloadable
  
  before_filter :find_project, :except => [:show, :destroy, :update]
  before_filter :find_doodle, :only => [:show, :destroy, :update]
  before_filter :authorize
  
  def index
    @doodles = @project.doodles
  end

  def new
    @doodle = Doodle.new(:project => @project)
  end

  def show
    @author = @doodle.author
    @reponses = @doodle.responses
    @comments = @doodle.comments
    @comments.reverse! if User.current.wants_comments_in_reverse_order?
    @ans = @doodle.options
  end

  def destroy
  end
  
  def create
    @doodle = Doodle.new(:project => @project, :author => User.current)
    @doodle.options = params[:doodle].delete(:options).split(',').map! { |s| s.squeeze(" ").strip }
    @doodle.attributes = params[:doodle]
    if @doodle.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => 'show', :id => @doodle
    else
      redirect_to :action => 'index', :project_id => @project
    end
  end
  
  def update
    user = User.current
    answers = @doodle.options.collect { |t| params[:answers].include?(@doodle.options.index(t).to_s) }
    response = @doodle.responses.find_or_initialize_by_author_id(user.id)
    response.answers = answers
    if response.save
      flash[:notice] = l(:doodle_update_successfull)
      redirect_to :action => 'show', :id => @doodle
    else
      flash[:warning] = l(:doodle_update_unseccessfull)
      redirect_to :action => 'show', :id => @doodle
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
end
