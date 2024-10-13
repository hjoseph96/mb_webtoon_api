class ApplicationController < ActionController::API
  include ::ActionController::Serialization

  protected

  def require_admin
    unless current_user.present? && current_user.admin?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
