class DoodlesController < ApplicationController
  unloadable
  
  before_filter :find_project, :only => [:index, :new]
  before_filter :find_doodle, :only => [:show]
  before_filter :authorize
  
  def index
    @doodles = @project.doodles
  end

  def new
    @doodle = Doodle.new(:project => @project, :author => User.current)
  end

  def show
    @author = @doodle.author
    @reponses = @doodle.responses
    @comments = @doodle.comments
    @comments.reverse! if User.current.wants_comments_in_reverse_order?
  end

  def destroy
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
