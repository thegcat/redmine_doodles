class DoodleAnswers < ActiveRecord::Base
  unloadable

  serialize :answers, Array
  
  belongs_to :doodle
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  has_many :edits, :class_name => 'DoodleAnswersEdits', :dependent => :delete_all
  
  validates_presence_of :answers
  
  after_save :create_edit
  
  def answers_with_css_classes
    [self.answers, self.css_classes].transpose
  end
  
  def css_classes
    return @css_classes unless @css_classes.nil?
    @css_classes = []
    self.answers.each_with_index do |answer,i|
      css = "answer"
      css << (answer ? " yes" : " no")
      @css_classes << css
    end
    @css_classes
  end
  
  private
  
  def create_edit
    edits << DoodleAnswersEdits.new(:edited_on => updated_on, :author_id => author_id)
  end
end
