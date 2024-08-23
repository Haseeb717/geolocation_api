# app/controllers/concerns/authenticable.rb
module Authenticable
  extend ActiveSupport::Concern

  private

  def authorize_request
    api_key = request.headers['Authorization']
    user = User.find_by(api_key: api_key)

    render json: { error: 'Unauthorized' }, status: :unauthorized unless user
  end
end
