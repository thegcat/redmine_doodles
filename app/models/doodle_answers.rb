class DoodleAnswers < ActiveRecord::Base
  serialize :answers, Array
  
  belongs_to :doodle
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  
  validates_presence_of :answers
  
  def answers_with_css_classes
    [self.answers, self.css_classes].transpose
  end
  
  def css_classes
    return @css_classes unless @css_classes.nil?
    @css_classes = []
    self.answers.each do |answer|
      css = "answer"
      css << " yes" if answer
      css << " no" unless answer
      @css_classes << css
    end
    @css_classes
  end
end
