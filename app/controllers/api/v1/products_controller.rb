module Api
  module V1
    class ProductsController < ApplicationController
      skip_before_action :verify_authenticity_token
      http_basic_authenticate_with name: 'admin', password: 'secret', only: [:auth]
      before_action :restrict_access, except: :auth

#     GET /access_token
      def auth
        if params[:id]
          product = Product.find_or_create_by(id:params[:id])
          product.make_access_token
          render json: { access_token: product.access_token }
        else
          render json: { satus: 404 }
        end
      end

      def unauth
        @product.invalidate_token
        render json: { status: 200 }
      end

      # GET /products
      def index
        @products = Product.all
        render 'index', formats: 'json', handlers: 'jbuilder'
      end

      # GET /products/1
      def show
        render 'show', formats: 'json', handlers: 'jbuilder'
      end

      # PATCH/PUT /products/1
      def update
        if @product.update(product_params)
          render 'show', formats: 'json', handlers: 'jbuilder'
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

      # DELETE /products/1
      def destroy
        if @product.destroy
          render 'destroy', formats: 'json', handlers: 'jbuilder'
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

      private

      # Never trust parameters from the scary internet, only allow the white list through.
      def product_params
        params.require(:product).permit(:name, :age, :email)
      end

      def restrict_access
        authenticate_or_request_with_http_token do |token, options|
          @product = Product.find_by(access_token: token)
          # @product && !@product.expired?
        end
      end
    end
  end
end
