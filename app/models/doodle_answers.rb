class DoodleAnswers < ActiveRecord::Base
  serialize :answers, Array
  
  belongs_to :doodle
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  
  validates_presence_of :answers
  
  def answers_with_css_classes(options = {})
    [self.answers, self.css_classes(options)].transpose
  end
  
  def css_classes(options = {})
    return @css_classes unless @css_classes.nil?
    @css_classes = []
    self.answers.each_with_index do |answer,i|
      css = "answer"
      css << (answer ? " yes" : " no")
      css << " winner" if options[:winners] && options[:winners].include?(i)
      @css_classes << css
    end
    @css_classes
  end
end
