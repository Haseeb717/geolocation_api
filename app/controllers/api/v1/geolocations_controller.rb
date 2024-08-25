# frozen_string_literal: true

# app/controllers/api/v1/geolocations_controller.rb

module Api
  module V1
    class GeolocationsController < ApplicationController
      include Authenticable

      # before_action :authorize_request
      before_action :set_geolocation, only: %i[show destroy update]

      def index
        geolocations = Geolocation.all
        geolocations = geolocations.where(ip_address: params[:ip_address]) if params[:ip_address].present?
        geolocations = geolocations.page(params[:page]).per(params[:per_page])

        render json: GeolocationSerializer.new(geolocations).serialized_json
      end

      def show
        render json: GeolocationSerializer.new(@geolocation).serialized_json
      end

      def create # rubocop:disable Metrics/MethodLength
        provider = params[:provider] || 'ipstack' # Default to ipstack if no provider is specified

        begin
          mapped_data = Providers::GeolocationService.call(
            provider, geolocation_params[:ip_address] || geolocation_params[:url]
          )

          @geolocation = Geolocation.new(mapped_data)

          if @geolocation.save
            render_success_response
          else
            render_error_response(@geolocation.errors.full_messages)
          end
        rescue Providers::Errors::GeolocationError => e
          render_error_response(e.message)
        end
      end

      def update # rubocop:disable Metrics/MethodLength
        provider = params[:provider] || 'ipstack'

        begin
          mapped_data = Providers::GeolocationService.call(provider, @geolocation.ip_address)

          if @geolocation.update(mapped_data)
            render_success_response
          else
            render_error_response(@geolocation.errors.full_messages)
          end
        rescue Providers::Errors::GeolocationError => e
          render_error_response(e.message)
        end
      end

      def destroy
        @geolocation.destroy
        head :no_content
      end

      private

      def geolocation_params
        params.require(:geolocation).permit(:ip_address, :url)
      end

      def set_geolocation
        @geolocation = Geolocation.find_by!(ip_address: params[:ip_address])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Geolocation not found' }, status: :not_found
      end

      def render_success_response
        render json: GeolocationSerializer.new(@geolocation).serialized_json, status: :created
      end

      def render_error_response(error_message)
        render json: { error: error_message }, status: :unprocessable_entity
      end
    end
  end
end
