class CreateDoodleAnswersEdits < ActiveRecord::Migration
  def self.up
    create_table :doodle_answers_edits do |t|
      t.column :doodle_answers_id, :integer
      t.column :author_id, :integer
      t.column :edited_on, :datetime
    end
  end

  def self.down
    drop_table :doodle_answers_edits
  end
end
