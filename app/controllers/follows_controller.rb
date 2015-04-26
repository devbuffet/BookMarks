class FollowsController < ApplicationController
		def add
			# authorized?
	       	validateLogin() 
			
			# add record to follow user
			@loggedInUser = returnLoggedinUser
		
			followCount = Follow.where("follower_id = ? AND user_id = ?", @loggedInUser.id , params[:id]).count

			# ensure they aren't already following the user
			if followCount == 0
				@objFollow = Follow.new()
				@objFollow.follower_id = @loggedInUser.id
				@objFollow.user_id = params[:id]
				@objFollow.save
			
				# success 
  				flash[:success_message] = "<strong>You're now following " + params[:name] + "!</strong>"    
			else
				# error 
  				flash[:error_message] = "<strong>You're already following " + params[:name] + "!</strong>"    				
			end	
			# redirect
			redirect_to :controller => "follows", :action => "index"
		end

		def index
			# defaults
    		# active tab => FOLLOW
    		@active_tab = "FOLLOW"
 	
	       	# authorized?
	       	validateLogin() 
	       	
	       	@loggedInUser = returnLoggedinUser

	       	if ! @loggedInUser.nil?
	       		# attrib
	    		@arrUserAttrib = [true,true,@loggedInUser.name,true]

	    		# who are you following?
			    @arrFollows = returnFollow('follows',@loggedInUser.id.to_s)
				
				# who's following you?
    			@arrFollowers = returnFollow('',@loggedInUser.id.to_s)
	   		 end
	   	end

       	def destroy
 
       		# authorized?
       		validateLogin() 
       	
       		@loggedInUser = returnLoggedinUser

       		# ensure they can unfollow the user...
			followCount = Follow.where("id = ? AND follower_id = ?", params[:id], @loggedInUser.id).count

			# they can't unfollow
			if followCount == 0 
				flash[:error_message] = "Sorry, invalid unfollow operation."
				redirect_to :action => "index", :controller => "articles"
			else
				# perform hard delete since this data is unimportant
				Follow.find(params[:id]).destroy
       			# success 
  				flash[:success_message] = "<strong>Successfully unfollowed " + params[:name] + "!</strong>"    
  				redirect_to :action => "index"
			end
        end 
end

