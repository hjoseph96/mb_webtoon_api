class HelloController < ApplicationController
  skip_before_action :authenticate!
  def index
    render json: { success: true, message: "Welcome to Mystery Babylon Webtoon API" }
  end
end