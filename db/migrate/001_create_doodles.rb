class CreateDoodles < ActiveRecord::Migration
  def self.up
    create_table :doodles do |t|
      t.column :title, :string
      t.column :project_id, :integer
      t.column :author_id, :integer
      t.column :description, :text
      t.column :options, :text
      t.column :expiry_date, :datetime
      t.column :created_on, :datetime
      t.column :updated_on, :datetime
    end
  end

  def self.down
    drop_table :doodles
  end
end
