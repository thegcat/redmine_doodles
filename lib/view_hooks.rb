module Plugin
  module Doodles
    class ViewHooks < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(context={ })
        stylesheet_link_tag 'redmine_doodles', :plugin => 'redmine_doodles'
      end
    end
  end
end