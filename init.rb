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
  version 'trunk'
  
  project_module :doodles do
    permission :manage_doodles, {:doodles => [:lock]}, :require => :member
    permission :create_doodles, {:doodles => [:new, :create]}, :require => :member
    permission :view_doodles, {:doodles => [:index, :show]}
    permission :answer_doodles, {:doodles => [:update]}, :require => :loggedin
  end
  menu :project_menu, :doodles, { :controller => 'doodles', :action => 'index' }, :caption => :label_doodle_plural, :param => :project_id
end
