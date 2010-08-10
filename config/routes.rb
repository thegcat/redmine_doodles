#custom routes for this plugin
ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'doodles' do |doodles_routes|
    doodles_routes.connect "projects/:project_id/doodles", :conditions => { :method => :get }, :action => 'index'
    doodles_routes.connect "projects/:project_id/doodles", :conditions => { :method => :post }, :action => 'create'
    doodles_routes.connect "projects/:project_id/doodles/new", :conditions => { :method => :get }, :action => 'new'
    doodles_routes.connect "projects/:project_id/doodles/preview", :conditions => { :method => [:post, :put] }, :action => 'preview'
    doodles_routes.connect "doodles/:id", :conditions => { :method => :get }, :action => 'show', :id => /\d+/
    doodles_routes.connect "doodles/:id", :conditions => { :method => :put }, :action => 'update', :id => /\d+/
    doodles_routes.connect "doodles/:id", :conditions => { :method => :delete }, :action => 'destroy', :id => /\d+/
    doodles_routes.connect "doodles/:id/edit", :conditions => { :method => :get }, :action => 'edit', :id => /\d+/
    doodles_routes.connect "doodles/:id/lock", :conditions => { :method => :post }, :action => 'lock', :id => /\d+/
    doodles_routes.connect "doodles/:id/answer", :conditions => { :method => :post }, :action => 'answer', :id => /\d+/
  end
end