module UsersHelper
	def validateSignUp(obj)
    # validates user sign-up
    error_message = ""
    if (!obj.name.present? || obj.name.size < 5) 
      error_message += "<div>Username must be at least 5 characters.</div>"
    elsif (!obj.password.present? || obj.password.size < 6)
      error_message += "<div>Password must be at least 6 characters.</div>"
    elsif (obj.password != obj.password_confirmation)
      error_message += "<div>Password must match confirmation.</div>"
    elsif (User.where(:email => obj.email).count == 1)
       error_message += "<div>This email already exists. Please choose another one.</div>"
    elsif (User.where(:name => obj.name).count == 1)
       error_message += "<div>This username already exists. Please choose another one.</div>" 
    elsif ((!obj.email.include? "@") || (!obj.email.include? "."))
      error_message += "<div>Please enter a valid email address.</div>"     
    end
    return error_message
  end
end
