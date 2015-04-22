class Article < ActiveRecord::Base
  
  include PgSearch
  pg_search_scope :search, :against => [:title, :link], 
  using: {tsearch: {:prefix => true}}

  #pg_search_scope :search, :against => { :title => 'A', :link => 'B' }, :using => { :tsearch => {:prefix => true} } 

   def self.text_search(query)
    if query.present?
      # search by keyword
      search(query)
    else
      # no keyword , just return everything
      scoped
    end
   end

   attr_accessible :category, :link, :title, :public, :user_id, :active

   # relationship
   belongs_to :user

   validates :title, presence: true,
                  length: { minimum: 5 }

   validates_presence_of :title, :link, :category, :message => " cannot be empty" 

end
