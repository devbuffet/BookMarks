class PasswordresetsController < ApplicationController
	# new request
	def new 
    	@user = User.new 
  end

    # save request
	def create 
  		 @user = User.new(user_params)

 		 # get the first record      
    	 @AccountUser = returnLoggedinInstance(@user.email)

    	 if @AccountUser.nil?
      	 	# invalid user...show them what went wrong...
      		flash[:error_message] = "<strong>Error:</strong> Email address does not exist in our system!"
    	 else
    	 	# success, generate code and email user
			  @AccountUser.code_tx = SecureRandom.hex(3).downcase
			  @AccountUser.save  
              # log activity
              logUserActivity("password reset request", @AccountUser.id) 
			  # send email
              UserMailer.passwordreset_sendMail(@AccountUser, "xxx: Password Reset.").deliver
              flash[:success_message] = "Security code sent to <strong>" + @AccountUser.email.to_s + "</strong> .Please check your inbox."
    	 end
    	 # render template
    	 render('new')
    end


    # validates user
    def validateToken

      	# start off empty
    	@user = User.new 

    	# validate user email/token pair
    	@AccountUser = User.where("id = ? and code_tx = ?", params[:id], params[:token]).first
    		
    	if @AccountUser.nil?
    		# show them what went wrong
    		flash[:error_message] = "<strong>Error:</strong> Invalid token. Please reset your password below."
    	 	render('new')
    	else
    		# redirect them to create new password
   			redirect_to :controller => "passwordgenerators", :action => "new", :token => @AccountUser.code_tx, :id =>  @AccountUser.id 	 	
    	end
    end

    # permit params
    private
   	 def user_params
    	params.require(:user).permit(:email)
  	 end 
end
