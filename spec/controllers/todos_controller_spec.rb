# frozen_string_literal: true

require 'rails_helper'
RSpec.describe TodosController, type: :controller do

describe "POST #create" do
  it "Creates todo" do
    post :create
    expect response.status == 200
  end

end

end