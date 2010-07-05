class Doodle < ActiveRecord::Base
  serialize :options, Array
  
  belongs_to :project
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  has_many :comments, :as => :commented, :dependent => :delete_all, :order => "created_on"
  has_many :responses, :class_name => 'DoodleAnswers', :dependent => :destroy, :order => "updated_on", :include => [:author]
  
  validates_presence_of :title, :options
  
  before_validation :sanitize_options
  
  def results
    responses.empty? ? options.fill(0) : responses.map(&:answers).transpose.map { |x| x.select { |v| v }.length }
  end
  
  def active?
    expiry_date.nil? ? true : DateTime.now < expiry_date
  end
  
  private
  
  def sanitize_options
    if options
      options.map! { |string| string.squeeze(" ").strip }
      options.delete_if { |string| string.empty? }
    end
  end
end
