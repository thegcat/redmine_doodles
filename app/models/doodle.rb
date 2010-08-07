class Doodle < ActiveRecord::Base
  unloadable
  
  serialize :options, Array
  
  belongs_to :project
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  has_many :comments, :as => :commented, :dependent => :delete_all, :order => "created_on"
  has_many :responses, :class_name => 'DoodleAnswers', :dependent => :destroy, :order => "updated_on", :include => [:author]
  has_many :comments, :as => :commented, :dependent => :delete_all, :order => "created_on"
  
  acts_as_watchable
  acts_as_event :title => Proc.new {|o| "#{l(:label_doodle)} ##{o.id}: #{o.title}"},
                :url => Proc.new {|o| {:controller => 'doodles', :action => 'show', :id => o.id}}
  acts_as_activity_provider :find_options => {:include => [:project, :author]},
                            :author_key => :author_id
  
  validates_presence_of :title, :options
  
  before_validation :sanitize_options
  
  after_create :add_author_as_watcher, :send_mails
  
  def results
    @results ||= responses.empty? ? Array.new(options.length, 0) : responses.map(&:answers).transpose.map { |x| x.select { |v| v }.length }
  end
  
  def active?
    !locked? && (expiry_date.nil? ? true : DateTime.now < expiry_date)
  end
  
  def winning_columns
    @winning_columns ||= self.results.max == 0 ? [] : self.results.enum_with_index.collect {|v,i| i if v == self.results.max}.compact
  end
  
  def previewfy
    self.locked = true
    sanitize_options
    self
  end
  
  def visible?(user=User.current)
    !user.nil? && user.allowed_to?(:view_doodles, project)
  end
  
  private
  
  def sanitize_options
    if options
      options.map! { |string| string.squeeze(" ").strip }
      options.delete_if { |string| string.empty? }
    end
  end
  
  def send_mails
    Mailer.deliver_doodle_added(self)
  end
  
  def add_author_as_watcher
    add_watcher(author)
  end
end
