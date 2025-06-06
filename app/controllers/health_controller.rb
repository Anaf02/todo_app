class HealthController < ApplicationController
  def show
    ActiveRecord::Base.connection.execute("SELECT 1")
    render plain: "OK", status: :ok
  rescue => e
    render plain: "FAIL", status: :service_unavailable
  end
end
