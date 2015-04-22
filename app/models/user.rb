class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :loginallowed, :code_tx, :avatar
  # relationship
  has_many :articles
  has_many :activity_logs
  has_secure_password
 
  #has_attached_file :avatar
  #ActivityLog.includes(:user).first.user.email 

end
