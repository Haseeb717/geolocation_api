# app/controllers/api/v1/geolocations_controller.rb

module Api
  module V1
    class GeolocationsController < ApplicationController
      include Authenticable

      before_action :authorize_request
      before_action :set_geolocation, only: [:show, :destroy]

      def index
        geolocations = Geolocation.all
        render json: GeolocationSerializer.new(geolocations).serialized_json
      end

      def show
        geolocation = Geolocation.find(params[:id])
        render json: GeolocationSerializer.new(geolocation).serialized_json
      end

      def create
        provider = params[:provider] || 'ipstack' # Default to ipstack if no provider is specified
        data = Providers::GeolocationService.call(provider, geolocation_params[:ip_address] || geolocation_params[:url])

        if data
          geolocation = Geolocation.new(data.merge(geolocation_params))
          if geolocation.save
            render json: geolocation, status: :created
          else
            render json: { error: geolocation.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: 'Failed to fetch geolocation data' }, status: :unprocessable_entity
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
        @geolocation = Geolocation.find(params[:id])
      end
    end
  end
end
