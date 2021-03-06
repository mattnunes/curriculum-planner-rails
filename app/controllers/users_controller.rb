require 'icalendar'

class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create]
  before_filter :admin_required, :only => [:index, :destroy]
  
  include Icalendar
  # # render new.rhtml
  def new
    @title = "Signup"
    @user = User.new
  end
  
  def index
    @title = "[Admin] User listing"
    @users = User.all
  end
  
  def destroy
    @user = User.find(params[:id])
    flash[:notice] = "User #{@user} deleted."
    @user.destroy

    redirect_to(users_path)
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_to("/home" , :notice => "Thanks for signing up! You can now begin using your account.")
    else
      flash.now[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def edit
    @title = "Edit"
    if is_group?("admin")
      @user = User.find_by_id(params[:id])
    else
      @user = current_user
    end
    
    render 'edit'
  end
  
  def update
    @user = User.find_by_id(params[:id])
    me = (@user == current_user)
    
    params[:user].each do |param, value|
      @user.update_attribute(param, value)
    end
    
    if me || (!me and is_group?("admin"))
      success = @user && @user.valid? && @user.save
      if success
        flash[:notice] = "Profile updated!"
      else
        flash[:error] = "There was a problem. We've dispatched error-sniffing monkeys. In the meantime, try correcting these errors."
      end
    else
      flash[:error] = "Ah, nice try komrad, but in Soviet Russia, account does not allow you to hack it (Yeah, figure THAT joke out). Alternatively, you do not have permissions to do that."
    end
    
    render 'edit'
  end
  
  def profile
    @title = "Home"
    @user = current_user
    if @user.name == @user.login
      flash[:notice] = "Hey you! yeah, what's-your-face! Personalize your profile!"
    end
    
    render 'my_profile'
  end
  
  def delete
    @user = User.find(params[:id])
    
    if @user
      @user.status = "deleted"
      @user.private = true
      
      if @user.save
        logout_killing_session!
        flash[:notice] = "Account deleted. Thanks for trying!"
      else
        flash[:error] = "Account could not be deleted."
      end
    else
      flash[:error] = "That user does not have exist."
    end
    
    redirect_to "/"
  end

  def show
    @user = User.find_by_id(params[:id])
    
    if @user.private? && !is_group?("admin")
      if @user == current_user
        flash[:notice] = "You do not have a public profile, but here's what it would look like if you did."
      else
        flash[:error] = "That user does not exist, or cannot be viewed.  So... here.  Amuse yourself with your own profile."
        @user = current_user
      end
    else
      flash[:notice] = "You are now viewing " + @user.to_s + "'s profile" + (is_group?("admin") ? ", admin override, normally " + (@user.private? ? "private" : "public") : "") + "."
    end
    
    @title = @user.to_s + "'s Profile"
    
    render 'public_profile'
  end

end
