#custom routes for this plugin
ActionController::Routing::Routes.draw do |map|
  map.resources :projects, :only => [] do |project|
    project.resources :doodles, :shallow => true, :new => {:preview => :post}, :member => {:lock => :post} do |doodle|
      doodle.resources :doodle_answers, :shallow => true, :only => [:create, :update]
    end
  end
end