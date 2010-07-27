module Plugin
  module Doodles
    module Project
      module ClassMethods
      end
      
      module InstanceMethods
      end
      
      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
        receiver.class_eval do
          unloadable
          has_many :doodles, :include => [:author, :responses, :comments]
        end
      end
    end
    
    module Mailer
      module ClassMethods
      end

      module InstanceMethods
        def doodle_added(doodle)
          redmine_headers 'Project' => doodle.project.identifier,
                          'Doodle-Id' => doodle.id
          message_id doodle
          recipients doodle.recipients
          subject "[#{doodle.project.name}] #{l(:label_doodle)}: #{doodle.title}"
          body :doodle => doodle,
               :doodle_url => url_for(:controller => 'doodle', :action => 'show', :id => doodle)
          render_multipart('doodle_added', body)
        end
        def doodle_answered(doodle_answer)
          redmine_headers 'Project' => doodle_answer.doodle.project.identifier,
                          'Doodle-Id' => doodle_answer.doodle.id
          message_id doodle_answer
          references doodle_answer.doodle
          recipients doodle_answer.doodle.recipients
          cc(doodle_answer.doodle.watcher_recipients - recipients)
          subject "[#{doodle_answer.doodle.project.name}] #{l(:label_doodle)}: #{doodle_answer.doodle.title}"
          body :doodle_answer => doodle_answer,
               :doodle_url => url_for(:controller => 'doodle', :action => 'show', :id => doodle_answer.doodle)
          render_multipart('doodle_answered', body)
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
    end
  end
end