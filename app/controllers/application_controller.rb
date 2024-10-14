class ApplicationController < ActionController::API
  include ::ActionController::Serialization

  before_action :authenticate!

  protected

  def authenticate!
    unless request.headers['Authorization'].present?
      render json: { error: 'Missing Authorization header' }, status: :unauthorized
      return
    end

    token = request.headers['Authorization'].gsub(/^Bearer\s+/, '')

    unless token.present?
      render json: { error: 'Missing token' }, status: :unauthorized
      return
    end

    token = JsonWebToken.decode(token)
    expiry_date = DateTime.strptime(token['exp'].to_s, '%s')
    unless DateTime.now < expiry_date
      render json: { error: 'Your token has expired...' }
      return
    end

    @current_user = User.find(token['user_id'])
  end
  def current_user
    @current_user
  end

  def require_login
    unless current_user.present?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def require_admin
    unless current_user.present? && current_user.admin?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

end
