require 'redmine'
require 'dispatcher'

Dispatcher.to_prepare do
  require_dependency 'project'
  require_dependency 'mailer'
  require 'patch_redmine_classes'
  
  Project.send(:include, ::Plugin::Doodles::Project)
  Mailer.send(:include, ::Plugin::Doodles::Mailer)
end

require_dependency 'view_hooks'

Redmine::Plugin.register :redmine_doodles do
  name 'Redmine Doodles plugin'
  author 'Felix Schäfer'
  description 'Per project doodles'
  version 'trunk'
  
  project_module :doodles do
    permission :manage_doodles, {:doodles => [:lock]}, :require => :member
    permission :create_doodles, {:doodles => [:new, :create, :preview]}, :require => :member
    permission :answer_doodles, {:doodles => [:update]}, :require => :loggedin
    permission :view_doodles, {:doodles => [:index, :show]}
  end
  
  menu :project_menu, :doodles, { :controller => 'doodles', :action => 'index' }, :caption => :label_doodle_plural, :param => :project_id
  
  activity_provider :doodles, :default => false, :class_name => ['Doodle', 'DoodleAnswersEdits']
end
