class Setloginallowedtrue < ActiveRecord::Migration
  def up
  	change_column :users, :loginallowed, :boolean, :default => true
  end

  def down
  end
end
