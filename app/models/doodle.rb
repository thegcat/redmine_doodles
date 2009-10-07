class Doodle < ActiveRecord::Base
  serialize :options, Array
  
  belongs_to :project
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  has_many :comments, :as => :commented, :dependent => :delete_all, :order => "created_on"
  has_many :responses, :class_name => 'DoodleAnswers', :dependent => :destroy, :order => "updated_on", :include => [:author]
  
  validates_presence_of :name, :options
end
