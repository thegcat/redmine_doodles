class UnfuckSerializedOptionsColumn < ActiveRecord::Migration
  def up
    raise "can't convert" unless defined?(Psych) && defined?(Syck)
    YAML::ENGINE.yamler = 'syck'
    Doodle.find_each do |d|
      d.update_column(:options, Psych.dump(d.options))
    end
  ensure
    YAML::ENGINE.yamler = 'psych'
  end

  def down
    ActiveRecord::IrreversibleMigration
  end
end
