require 'redmine'
require 'dispatcher'

Dispatcher.to_prepare do
  require_dependency 'project'
  require 'patch_redmine_classes'
  
  Project.send(:include, ::Plugin::Doodles::Project)
end

Redmine::Plugin.register :redmine_doodles do
  name 'Redmine Doodles plugin'
  author 'Felix Schäfer'
  description 'Per project doodles'
  version '0.0.1'
  
  project_module :doodles do
    permission :view_doodles, { :doodles => [:index, :show, :new, :create, :update]}
  end
  menu :project_menu, :doodles, { :controller => 'doodles', :action => 'index' }, :caption => :label_doodle_plural, :param => :project_id
end
