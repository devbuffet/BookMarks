module ApplicationHelper

	def setActiveState (page_indx,indx)
		# increment by 1 since page really starts at 1
		# default should show the first page active
		if ((indx ==0 && page_indx==0) || page_indx == indx + 1)
			return "active"
		end
	end

	def setPrevState (page_indx)
		# configures prev state...no pages left
		return (page_indx >=0 && page_indx <=1 ? "disabled": "")
	end

	def setNextState (page_indx,collection_count)
		# configures next state...no pages left
		return (collection_count == 1 || page_indx == collection_count ? "disabled": "")
	end

	def returnMsgNotify(message_type)		
		# customize alert message type	
		case message_type
			when "success_message"   
  				return "alert alert-success alert-dismissible"	
			when "error_message"
  				return "alert alert-danger alert-dismissible"	
		end
	end
	
	def returnErrorMessage(obj)
		# start empty
  		message_tx = nil
  		# error count
  		message_tx = "<h3>" + obj.errors.count.to_s + " issue(s) found:</h3>" 
  		# loop each and construct it
  		obj.errors.full_messages.each do |msg|
       		message_tx += "<div>" + msg + "</div>"
  		end
		return message_tx
	end

	# returns logged in user
	def returnLoggedinUser
    	return User.where(:password_digest => cookies[:password_hash]).first
    end

    # log activity
    def logUserActivity(action_tx, user_id = 0)
    	# do we have a user_id?
    	logged_in_user_id = returnLoggedinUser
    	# if user is not logged in set to 0
    	logged_in_user_id = (logged_in_user_id.nil? ? 0 : logged_in_user_id.id)

  	    objActivityLog = ActivityLog.new
	    objActivityLog.user_id = (user_id > 0 ? user_id : logged_in_user_id)
	    objActivityLog.action_tx = action_tx
	    if objActivityLog.user_id > 0
	    	objActivityLog.save
	    end
    end

    # reuturns logged-in instance
    def returnLoggedinInstance(email)
    	 # get the first record      
    	 return User.where(:email => email).first
    end

    # returns category collection
    def returnCategoryCollection
    	arrCollection = []
    	# default entry
    	arrCollection.push(['- Choose--',''])
    	# turn category into array
    	arrCategory = Rails.application.config.arrCategory.split(',')
    	# loop and push each one
		arrCategory.each do |item| 
			arrCollection.push([item,item])  
		end
		# return collection
		return arrCollection
    end

end
 