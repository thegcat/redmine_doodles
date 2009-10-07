#custom routes for this plugin
ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'doodles' do |doodles_routes|
    doodles_routes.connect "projects/:project_id/doodles", :conditions => { :method => :get }, :action => 'index'
    doodles_routes.connect "projects/:project_id/doodles", :conditions => { :method => :post }, :action => 'create'
    doodles_routes.connect "projects/:project_id/doodles/new", :conditions => { :method => :get }, :action => 'new'
    doodles_routes.connect "doodles/:id", :conditions => { :method => :get }, :action => 'show', :id => /\d+/
  end
end