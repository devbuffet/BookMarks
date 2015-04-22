class Addloginflag < ActiveRecord::Migration
  def up
  	add_column :users, :loginallowed, :boolean
  end

  def down
  end
end
