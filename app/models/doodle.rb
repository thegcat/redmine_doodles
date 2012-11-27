class Doodle < ActiveRecord::Base
  unloadable
  
  serialize :options, Array
  
  belongs_to :project
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  has_and_belongs_to_many :should_answer, :class_name => 'User', :join_table => "#{table_name_prefix}users_should_answer_doodles#{table_name_suffix}"
  has_many :comments, :as => :commented, :dependent => :delete_all, :order => "created_on"
  has_many :responses, :class_name => 'DoodleAnswers', :dependent => :delete_all, :order => "updated_on", :include => [:author]
  
  acts_as_watchable
  acts_as_event :title => Proc.new {|o| "#{l(:label_doodle)} ##{o.id}: #{o.title}"},
                :url => Proc.new {|o| {:controller => 'doodles', :action => 'show', :id => o.id}}
  acts_as_activity_provider :find_options => {:include => [:project, :author]},
                            :author_key => :author_id
  
  validates :title, :options, :presence => true
  
  before_validation :sanitize_options
  
  after_create :add_author_as_watcher, :send_mails
  
  def results
    old_answers = responses.map(&:answers)[0]
    new_answers = responses.map(&:answers)[1]
    answers = nil
    if( !(old_answers.nil?) && !(new_answers.nil?) && !(old_answers.length == new_answers.length))
      temp = Array.new(new_answers.length, false)
      temp2 = old_answers.length < new_answers.length ? old_answers : new_answers
      temp2.each_with_index do |el,i|
        temp[i] = old_answers[i]
      end
      answers = [temp,new_answers]
      responses.map(&:answers)[0] = temp
    else
      answers = responses.map(&:answers)
    end
    @results ||= responses.empty? ? Array.new(options.length, 0) : answers.transpose.map { |x| x.select { |v| v }.length }
#    @results ||= responses.empty? ? Array.new(options.length, 0) : responses.map(&:answers).transpose.map { |x| x.select { |v| v }.length }
  end
  
  def active?
    !locked? && (expiry_date.nil? ? true : DateTime.now < expiry_date)
  end
  
  def winning_columns
    @winning_columns ||= self.results.max == 0 ? [] : self.results.each_with_index.collect {|v,i| i if v == self.results.max}.compact
  end
  
  def previewfy
    self.locked = true
    sanitize_options
    self
  end
  
  def visible?(user=User.current)
    !user.nil? && user.allowed_to?(:view_doodles, project)
  end
  
  def users_missing_answer
    @users_missing_answer ||= should_answer - responses.collect(&:author)
  end
  
  def should_answer_recipients
    @should_answer_recipients ||= should_answer.collect(&:mail)
  end
  
  private
  
  def sanitize_options
    if options
      options.map! { |string| string.squeeze(" ").strip }
      options.delete_if { |string| string.empty? }
    end
  end
  
  def send_mails
    #Mailer.deliver_doodle_added(self)
    #Mailer.deliver_doodle_added_with_answer_request(self)
  end
  
  def add_author_as_watcher
    add_watcher(author)
  end
end
