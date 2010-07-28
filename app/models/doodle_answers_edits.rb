class DoodleAnswersEdits < ActiveRecord::Base
  unloadable

  belongs_to :doodle_answers
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  
  acts_as_event :title => Proc.new {|o| "#{l(:label_doodle)} ##{o.doodle_answers.doodle.id}: #{o.doodle_answers.doodle.title}"},
                :url => Proc.new {|o| {:controller => 'doodles', :action => 'show', :id => o.doodle_answers.doodle.id}},
                :datetime => :edited_on,
                :description => nil,
                :type => "doodle-answers"
  acts_as_activity_provider :find_options => {:include => [{:doodle_answers => {:doodle => :project}}, :author]},
                            :author_key => :author_id,
                            :type => "doodles",
                            :permission => :view_doodles,
                            :timestamp => "#{table_name}.edited_on"
                            
  after_create :send_mails
                            
  def project
    doodle_answers.doodle.project
  end
  
  private
  
  def send_mails
    Mailer.deliver_doodle_answered(self)
  end
end
