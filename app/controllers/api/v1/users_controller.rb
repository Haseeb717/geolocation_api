# app/controllers/users_controller.rb

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user, only: [:show_api_key, :regenerate_api_key]

      def create
        user = User.new(user_params)
        if user.save
          render json: { api_key: user.api_key, message: 'User created successfully' }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show_api_key
        render json: { api_key: @current_user.api_key }
      end

      def regenerate_api_key
        @current_user.regenerate_api_key
        render json: { api_key: @current_user.api_key, message: 'API key regenerated successfully' }
      end

      private

      def authenticate_user
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          @current_user = user
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end
