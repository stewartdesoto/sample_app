class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      log_in @user #in sessionshelper, available through include in applicationshelper
      #remember(@user) # in sessionshelper
      flash[:success] = "Welcome to Sample App"
  		redirect_to user_path(@user)
  	else
  		render 'new'
  	end
  end

  def show
  	@user = User.find(params[:id])
  	#debugger if Rails.env.development?
  end

  private
  	def user_params
  		params.require(:user).permit(:name, :email,
  			:password, :password_confirmation)
  	end

end
