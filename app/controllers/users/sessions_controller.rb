class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    resource = User.find_for_database_authentication(email: params[:user][:email])
    return failure unless resource
    return failure unless resource.valid_password?(params[:user][:password])

    render status: :ok,
           json: {
             success: true,
             user: resource,
             auth_token: current_user.authentication_token
           }
  end

  def failure
    render status: :ok,
           json: {
             success: false,
             info: "Login failed"
           }
  end
end
