class ArticlesController < ApplicationController  
  def help
    # active tab => HELP
    @active_tab = "HELP"
  end

  def category

    # authorized?
    validateLogin()

    # give page a title
    @title = "Bookmarks filed under <i>" + params[:category].to_s + "</i>"
    # posts based on category
    @articles = Article.where("public = ? AND category = ? AND active = ?", true, params[:category],true)
    .includes(:user)
    .order("Created_at DESC")
    # user/category 
    @arrUserAttrib = [true,false,"bookmark"]  

    # log activity
    logUserActivity("viewed category: " + params[:category].to_s) 

  end

  def show 

    @loggedInUser = returnLoggedinUser

    if !@loggedInUser.nil?
      # logged in
      article = Article.where("id = ? AND active = ?", params[:id],true).first
    else
      # logged out
      article = Article.where("id = ? AND public = ? AND active = ?", params[:id],true,true).first
    end

    # authorized?
    if @loggedInUser.nil?   
      validateLogin()
    else
      if article.nil?
        # warn user
        flash[:error_message] = "Invalid bookmark access."    
        render('show')
      else
        # log activity
        logUserActivity("viewed bookmark: " + params[:id].to_s) 
        # redirect to bookmark link
        redirect_to article.link
      end
    end
  end

  def index
    # defaults
    
    # account terminated?
    if !params[:code].blank? then
       flash[:success_message] = "<strong>Your account has been deactivated.</strong>"   
    end

    # active tab => HOME
    @active_tab = "HOME"
    
    @nextText = "Next &raquo;".html_safe
    @prevText = "&laquo; Previous".html_safe

    @per_page = 30

    page_indx = (params[:page_indx].present? ? params[:page_indx] : 1).to_i
    
    # start off with empty collection
    @articles = nil
    
    # perform search
    # association
    @articles = Article.where("active = ?", true).includes(:user)
    .text_search(params[:search_tx])
    .order("Created_at " + (params[:sortOrder_tx].present? ? params[:sortOrder_tx] : "DESC"))
    
    @loggedInUser = returnLoggedinUser

    if(@loggedInUser.nil?)
      # logged out; only show public posts
      @articles = @articles.where("public = ?", true)
    end             

    # x per page
    # @record_count = @articles.count
    @collection_count = ((@articles.count.to_f) / @per_page.to_f).ceil

    # paginate results
    @articles = @articles.offset( @per_page * (page_indx - 1)).limit(@per_page)

    # log activity
    if !params[:search_tx].nil?
      logUserActivity("searched for: " + params[:search_tx].to_s) 
    end  
  end

  def new
    # active tab => ADD
    @active_tab = "ADD"
    
    # authorized?
    validateLogin()
    
    @btnName_tx = "Save"
    @article = Article.new
    
    # posts are public by default
    @article.public = true
  end

  def create

    # authorized?
    validateLogin()

    @article = Article.new(article_params)

    # set foreign field -> user_id
    @article.user_id = returnLoggedinUser.id

    if @article.save
     # log activity
     logUserActivity("added bookmark: " + @article.id.to_s) 
     # success 
     flash[:success_message] = "<strong>Success!</strong> Your bookmark has been added."    
     redirect_to :action => "index"
   else
    @btnName_tx = "Add"
    render ('new')
  end
end

def edit

  userLoggedIn = returnLoggedinUser()

  @btnName_tx = "Update"
  @article = Article.find(params[:id])

    # get post owner info
    postOwner = @article.user_id

    if postOwner != userLoggedIn.id
        # flash user
        flash[:error_message] = "<strong>Sorry you are not the bookmark owner.</strong>"
        redirect_to :action => "index"
      end
    end

    def returnAttribChange(oldarticle, newarticle)
    # track what changed?
    # start of empty
    message_tx = "";
    # append applicable attrib changes
    if oldarticle.title != newarticle.title
     message_tx += ";Title changed from " + oldarticle.title + " to " + newarticle.title
   end
   if oldarticle.category != newarticle.category
     message_tx += ";Category changed from " + oldarticle.category + " to " + newarticle.category
   end
   if oldarticle.public != newarticle.public
     message_tx += ";Public changed from " + oldarticle.public.to_s + " to " + newarticle.public.to_s 
   end 
   return message_tx
 end

 def update
  @btnName_tx = "Update"
  
  @article = Article.find(params[:id])

    # what changed?
    message_tx = returnAttribChange(@article, (Article.new(article_params)))

    if !message_tx.blank?
      # log activity
      logUserActivity("updated bookmark: " + @article.id.to_s + message_tx)  
      # update entry
      @article.update_attributes(article_params)
      # success 
      flash[:success_message] = "<strong>Success!</strong> Your bookmark has been updated."  
      redirect_to :action => "index"
    else
      # dirty flag did not change...warn them
      flash[:error_message] = "Please update something."  
      render ('edit')
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.active = false
    @article.save
  # log activity
  logUserActivity("deleted bookmark: " + @article.id.to_s) 
  # success 
  flash[:success_message] = "<strong>Success!</strong> Your bookmark has been deleted."    
  redirect_to :action => "index"
end

private
def article_params
  params.require(:article).permit(:title, :link, :category, :public, :user_id, :active)
end
end