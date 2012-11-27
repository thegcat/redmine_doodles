#custom routes for this plugin
#ActionController::Routing::Routes.draw do |map|
#  map.resources :projects, :only => [] do |project|
#    project.resources :doodles, :shallow => true, :new => {:preview => :post}, :member => {:lock => :post} do |doodle|
#      doodle.resources :doodle_answers, :shallow => true, :only => [:create, :update]
#    end
#  end
#end

#custom routes for this plugin
RedmineApp::Application.routes.draw do
  shallow do
    resources :projects, :only => [] do
      resources :doodles do
        post :preview
        get :member
        post :lock
        resources :doodle_answers
      end
    end
  end
end