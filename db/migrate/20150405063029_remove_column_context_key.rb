class RemoveColumnContextKey < ActiveRecord::Migration
  def up
  	remove_column :activity_logs, :context_id
  end

  def down
  end
end
