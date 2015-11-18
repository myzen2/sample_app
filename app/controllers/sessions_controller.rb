class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message = "Compte non activé."
        message += "Vérifiez vos emails pour obtenir le lien d'activation"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Combinaison email/mot de passe invalide !'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
