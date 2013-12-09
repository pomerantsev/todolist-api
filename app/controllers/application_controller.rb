class ApplicationController < ActionController::API
  # CORS actions: http://stackoverflow.com/questions/17858178/allow-anything-through-cors-policy
  after_action :cors_set_access_control_headers

  def cors_preflight_check
    set_headers
    head :no_content
  end

protected

  # From here: https://gist.github.com/josevalim/fb706b1e933ef01e4fb6
  def authenticate_user_from_token!
    user_email = params[:user_email].presence
    user = user_email && User.find_by(email: user_email)

    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: false
    end
  end

private
  
  def cors_set_access_control_headers
    set_headers
  end

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, DELETE, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

end
