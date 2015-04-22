class UsersController < ApplicationController
  def profile
    # get the user
    # user's profile
    @UserName = User.where("name = ? and loginallowed = ?", params[:name], true).first

    if @UserName.blank?
      # show them what went wrong...
      flash[:error_message] = "<strong>Error:</strong> Invalid UserName!"
      render ('profile')
    else
      # show user's public posts
      @articles = Article.where("user_id = ? AND public = ? AND active = ?", @UserName.id, true,true)
                     .includes(:user)
                     .order("Category, Created_at DESC")

     # give page a title
     @title = "<i>" + params[:name].to_s + "'s</i> bookmarks"

     # user/category 
     @arrUserAttrib = [false,true,"user"]

     # log activity
      logUserActivity("viewed profile: " + params[:name].to_s) 
    end
  end

	def new 
    # active tab => REGISTER
    @active_tab = "REGISTER"
  
		@user = User.new

    # set attrib 
    @arrAttrib = returnAttrib(true)

  end

  # only used for changing password
  def edit
    # set attrib 
    @arrAttrib = returnAttrib(false)

    @user = User.find(params[:id])

    # ensure email and token are valid
    @AccountUser = User.where("id = ? and code_tx = ?", params[:id], params[:token]).first
      
    if @AccountUser.nil?
      #invalid user
      #show them what went wrong...
      @user = nil
      flash[:error_message] = "<strong>Error:</strong> Invalid Access!"
    end    
  end

  # used for password reset
  def update
    # set attrib 
    @arrAttrib = returnAttrib(false)

    @user = User.find(params[:id])
    
    message_tx = validatePassword(User.new(user_params))

    if !message_tx.blank?
      # show them what went wrong...
      flash[:error_message] = message_tx
      render ('edit')
    else
      # nullify code
      @user.code_tx = nil
      @user.update_attributes(user_params)
      # log activity
      logUserActivity("password reset", @user.id) 
      # show success
      flash[:success_message] = "You have successfully reset your password. Please login below."
      # redirect to login page
      redirect_to :controller => "sessions", :action => "new"
    end
  end

  # returns attributes
  def returnAttrib(register_fg)
    if(register_fg)
      return ['Create a Free Account','','','','','Register','']
    else
      return ['Create New Password','hide','hide','','','Submit','']
    end   
  end

  def create
    # attrib 
    @arrAttrib = returnAttrib(true)

    @user = User.new(user_params)

    # downcase the email
    @user.email= @user.email.downcase

    # validate user info
    message_tx = validateSignUp(@user)

    if(!message_tx.blank?)
      # show them what went wrong...
      flash[:error_message] = message_tx
      render ('new')
    else (@user.save)
      # create cookie
      cookies[:password_hash] = @user.password_digest
      # flash user
      flash[:success_message] = "<strong>Success!</strong> Your account has been created."
      # log activity
      logUserActivity("user signup") 
      # send email
      UserMailer.signup_sendMail(@user, ENV['siteName'] + ": Your Account Info.").deliver
      # redirect them
      redirect_to :controller => "articles", :action => "new"    
    end
  end

private
  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :loginallowed, :code_tx, :avatar)
  end 

    def validateSignUp(obj)
      # validates user sign-up
      error_message = ""

      if (!obj.name.present? || obj.name.size < 5) 
        error_message += "<div>Username must be at least 5 characters.</div>"
      elsif /^[a-zA-Z0-9]*$/.match(obj.name).nil?
        error_message += "<div>Username can only contain letters/numbers. Special characters not allowed.</div>"
      elsif (User.where(:email => obj.email).count == 1)
         error_message += "<div>This email already exists. Please choose another one.</div>"
      elsif (User.where(:name => obj.name).count == 1)
         error_message += "<div>This username already exists. Please choose another one.</div>" 
      elsif ((!obj.email.include? "@") || (!obj.email.include? "."))
        error_message += "<div>Please enter a valid email address.</div>"     
      end
      
      # refactored this to use same function
      error_message += validatePassword(obj)

    return error_message
  end

   # validates password
  def validatePassword(obj)
    # start empty
      error_message = ""
    if (!obj.password.present? || obj.password.size < 6)
        error_message += "<div>Password must be at least 6 characters.</div>"
    elsif (obj.password != obj.password_confirmation)
        error_message += "<div>Password must match confirmation.</div>"
    end
    return error_message
  end   

end
