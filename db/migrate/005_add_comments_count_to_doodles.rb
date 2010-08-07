class AddCommentsCountToDoodles < ActiveRecord::Migration
  def self.up
    add_column :doodles, :comments_count, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :doodles, :comments_count
  end
end