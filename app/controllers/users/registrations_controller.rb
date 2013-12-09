class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)
    if resource.save
      sign_in resource
      render status: :ok,
             json: {
               user: resource,
               auth_token: current_user.authentication_token
             }
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end
end
