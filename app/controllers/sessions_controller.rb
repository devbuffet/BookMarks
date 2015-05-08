class SessionsController < ApplicationController
	def new 
     # already logged in?
    checkLoginStatus()

     # active tab => LOGIN
    @active_tab = "LOGIN"

		@user = User.new
  end

  def create
   
  	@user = User.new(user_params)
    
    # get the first record      
    @AccountUser = returnLoggedinInstance(@user.email)
  
    # authenticate the user
    if !@AccountUser.nil? && @AccountUser.authenticate(@user.password) && @AccountUser.loginallowed
        # create a new password?
        if !@AccountUser.code_tx.blank?
          # force user to create new password
          redirect_to :controller => "users", :action => "edit", :token => @AccountUser.code_tx, :id =>  @AccountUser.id    
        else
          # cookie them
          cookies[:password_hash] = @AccountUser.password_digest
          # log activity
          logUserActivity("login") 
          # redirect them
          redirect_to :controller => "articles", :action => "index"   
        end
    else
        if !@AccountUser.nil? && !@AccountUser.loginallowed
         # flash user
          flash[:error_message] = "<strong>Your account has been disabled.</strong>"                  
        else
          # flash user
          flash[:error_message] = "<strong>Login information incorrect. Please try again.</strong>"          
        end
        # show them whats wrong...
        render('new')
     end
  end

  def logout
    # log activity
    logUserActivity("logout") 
    # delete the cookie
    cookies.delete :password_hash
    # redirect
    redirect_to :action => "index", :controller => "articles", :code => params[:code]
  end

private
  def user_params
    params.require(:user).permit(:email, :password)
  end 
end
