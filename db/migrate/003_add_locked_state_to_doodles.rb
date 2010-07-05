class AddLockedStateToDoodles < ActiveRecord::Migration
  def self.up
    add_column :doodles, :locked, :boolean, :default => 0
  end

  def self.down
    remove_column :doodles, :locked
  end
end
