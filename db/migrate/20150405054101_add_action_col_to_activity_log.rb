class AddActionColToActivityLog < ActiveRecord::Migration
  def change
  	add_column :activity_logs, :action_tx, :string
  end
end
