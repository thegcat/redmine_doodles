module Plugin
  module Doodles
    module Project
      def self.included(receiver)
        receiver.class_eval do
          unloadable
          has_many :doodles, include: [:author, :responses, :comments]
        end
      end
    end

    module Mailer
      def doodle_added(doodle)
        redmine_headers 'Project' => doodle.project.identifier,
          'Doodle-Id' => doodle.id
        @author = doodle.author
        message_id doodle
        recipients = doodle.recipients - doodle.should_answer_recipients
        cc = doodle.watcher_recipients - recipients - doodle.should_answer_recipients
        @doodle = doodle
        @doodle_url = url_for(controller: 'doodles', action: 'show', id: doodle)
        mail to: recipients,
          cc: cc,
          subject: "[#{doodle.project.name}] #{l(:label_doodle)}: #{doodle.title}"
      end

      def doodle_added_with_answer_request(doodle)
        redmine_headers 'Project' => doodle.project.identifier,
          'Doodle-Id' => doodle.id
        @author = doodle.author
        message_id doodle
        recipients = doodle.should_answer_recipients
        @doodle = doodle
        @doodle_url = url_for(controller: 'doodles', action: 'show', id: doodle)
        mail to: recipients,
          subject: "[#{doodle.project.name}] #{l(:label_doodle)}: #{doodle.title}"
      end

      def doodle_answered(doodle_answer_edit)
        doodle_answer = doodle_answer_edit.doodle_answers
        redmine_headers 'Project' => doodle_answer.doodle.project.identifier,
          'Doodle-Id' => doodle_answer.doodle.id
        @author = doodle_answer.author
        message_id doodle_answer_edit
        references doodle_answer.doodle
        recipients = doodle_answer.doodle.recipients
        cc = doodle_answer.doodle.watcher_recipients - recipients
        @doodle_answer = doodle_answer
        @doodle_url = url_for(controller: 'doodles', action: 'show', id: doodle_answer.doodle)
        mail to: recipients,
          cc: cc,
          subject: "[#{doodle_answer.doodle.project.name}] #{l(:label_doodle)}: #{doodle_answer.doodle.title}"
      end
    end
  end
end
