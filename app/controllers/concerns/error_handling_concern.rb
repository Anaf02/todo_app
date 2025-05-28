# frozen_string_literal: true

module ErrorHandlingConcern
  extend ActiveSupport::Concern
  included do
    rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

    def render_failures(errors, status)
      render json: { error: errors }, status: status
    end

    def handle_parameter_missing(exception)
      render json: { error: exception.message }, status: :unprocessable_entity
    end

    def handle_record_not_found(exception)
      render json: { error: exception.message }, status: :not_found
    end
  end
end
