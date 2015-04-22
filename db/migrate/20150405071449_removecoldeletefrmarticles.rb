class Removecoldeletefrmarticles < ActiveRecord::Migration
  def up
  	remove_column :articles, :delete

  end

  def down
  end
end
