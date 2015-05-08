class UserauthsController < ApplicationController
	
   # new request
	def new 

    # authorized?
    validateLogin()
		
    # active tab => DEACTIVATE
    @active_tab = "DEACTIVATE"
    @user = User.new 
  end

  	# save request
	def create 
    
    # set logged in user instance var
    @loggedInUser = User.find(returnLoggedinUser.id)
    
    @user = User.new(user_params)

    if !@loggedInUser.authenticate(@user.password)
      # error 
      flash[:error_message] = "Incorrect password!"
      render('new')
    else
      # deactivate account
      @loggedInUser.loginallowed = false
      @loggedInUser.save
      # redirect them...
      redirect_to :controller=>"sessions", :action => "logout", :code => 0
    end
  end

      # permit params
    private
     def user_params
      params.require(:user).permit(:password,:loginallowd)
     end 

end
