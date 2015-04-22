class ActivityLog < ActiveRecord::Base
  attr_accessible :user_id, :action_tx
  # relationship
  belongs_to :user
end
