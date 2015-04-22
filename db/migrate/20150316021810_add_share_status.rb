class AddShareStatus < ActiveRecord::Migration
  def up
  	add_column :articles, :public, :boolean
  end

  def down
  end
end
