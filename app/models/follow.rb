class Follow < ActiveRecord::Base
  # follower_id follows user_id
  attr_accessible :follower_id, :user_id

  # relationship
  belongs_to :user

end
