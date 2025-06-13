# frozen_string_literal: true

class AuthController < ApplicationController
  def signup
    client_app = Doorkeeper::Application.find_by(uid: params[:client_id])

    unless client_app
      return render json: { error: I18n.t("doorkeeper.errors.messages.invalid_client") },
                    status: :unauthorized
    end

    @user = User.new(user_params)
    @user.save

    unless @user
      render json: { message: "registration failed" }, status: :unprocessable_entity
    end

    @results = model_results(@user, client_app)

    @results
  end

  def login
    response = strategy.authorize
    @token = response.status == :ok ? response.token : nil
    if @token&.resource_owner_id
      @user ||= User.find(@token.resource_owner_id)
    end

    self.response_body =
      if response.status == :unauthorized
        render json: { error: "unauthorized" }, status: 404
      else
        user_json(@user, @token)
      end
  end
end

private

def model_results(user, client_app, token_type = "Bearer")
  access_token = Doorkeeper::AccessToken.find_or_create_for(
    resource_owner: user.id,
    application: client_app,
    refresh_token: generate_refresh_token,
    expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
    scopes: ""
  )

  { user: user, tokens: { refresh_token: access_token.refresh_token, access_token: access_token.token } }
end

def generate_refresh_token
  loop do

    token = SecureRandom.hex(32)

    break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
  end
end

def user_json(user, token)
  {
    user: user,
    auth: {

      access_token: token.token,
      refresh_token: token.refresh_token
    }
  }.to_json
end

def user_params
  params.require(:user).permit(:email, :password, :password_confirmation)
end
