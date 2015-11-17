class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy


  def new
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
  end

  def index
    #@users = User.all
    #@users = User.paginate(page: params[:page])
    @users = User.paginate(:page => params[:page], :per_page => 10)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Bienvenue to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  def update
   @user = User.find(params[:id])
    if @user.update_attributes(user_params)
     flash[:success] = "Les informations ont été mises à jour"
     redirect_to @user
    else
     render 'edit'
    end
  end
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Veuillez vous connecter."
      redirect_to login_url
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Utilisateur effacé"
    redirect_to users_url
  end



  private
    def user_params
      params.require(:user).permit(:nom, :email, :password, :password_confirmation)
    end
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Merci de bien vouloir vous connecter."
        redirect_to login_url
      end
    end
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
