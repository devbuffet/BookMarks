class Addisactivearticles < ActiveRecord::Migration
  def up
  	add_column :articles, :active, :boolean, :default => true
  end

  def down
  end
end
