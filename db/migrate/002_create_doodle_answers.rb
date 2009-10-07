class CreateDoodleAnswers < ActiveRecord::Migration
  def self.up
    create_table :doodle_answers do |t|
      t.column :answers, :text
      t.column :doodle_id, :integer
      t.column :author_id, :integer
      t.column :created_on, :datetime
      t.column :updated_on, :datetime
    end
  end

  def self.down
    drop_table :doodle_answers
  end
end
