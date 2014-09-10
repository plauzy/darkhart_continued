class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def signin
    user = User.find(params[:user_id])
    if user && user.authenticate(params[:password])
      render json: {token:user.remember_token}
    else
      render :status => 401
    end
  end

  def create
   @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to Dark Heart!"
      # session[:user_id] = @user.id
      # redirect_to @user
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.password == params[:user][:password] && @user.update_attributes(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render json: @user, notice: 'User updated.' }
      else
        format.html { render action: "show" }
        format.json { render json: {:error => "Invalid Password"} }
      end
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

end
