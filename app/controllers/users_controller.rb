class UsersController < ApplicationController
  #before_filter :admin_required, :for => [:show]
   #before_filter :login_required, :for => :show
  # Be sure to include AuthenticationSystem in Application Controller instead
  
  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      @sched = Schedule.new({:user => @user})
      redirect_to("/", :notice => "Thanks for signing up!  We're sending you an email with your activation code.")
    else
      flash.now[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      redirect_to '/login', :notice => "Signup complete! Please log in to continue."
    when params[:activation_code].blank?
      redirect_back_or_default('/')
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
    else 
      redirect_back_or_default('/')
      flash[:error] = "We couldn't find a user with that activation code " + text("mdash") + " check your email? Or maybe you've already activated; try signing in."
    end
  end
  
  def show
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end
  
  def profile
    @user = current_user
    render 'show'
  end

end