class AddColSoftDeleteToArticles < ActiveRecord::Migration
  def change
  	add_column :articles, :delete, :boolean, :default => false
  end
end
