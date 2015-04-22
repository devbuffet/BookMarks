class Changecoltypeaction < ActiveRecord::Migration
  def up
  	change_column :activity_logs, :action_tx, :text
  end

  def down
  end
end
