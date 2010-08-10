class CreateUsersShouldAnswerDoodles < ActiveRecord::Migration
  def self.up
    create_table :users_should_answer_doodles, :id => false do |t|
      t.column :user_id, :integer, :null => false
      t.column :doodle_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :users_should_answer_doodles
  end
end