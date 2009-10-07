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
  end
end