class AddCodeColumnToUser < ActiveRecord::Migration
  def change
  	add_column :users, :code_tx, :string
  end
end
