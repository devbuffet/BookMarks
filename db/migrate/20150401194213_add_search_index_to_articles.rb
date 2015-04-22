class AddSearchIndexToArticles < ActiveRecord::Migration
  def change
  	execute "create index articles_title on articles using gin(to_tsvector('english',title))"
  end
end
