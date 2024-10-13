class HelloController < ApplicationController
  def index
    render json: { success: true, message: "Welcome to Mystery Babylon Webtoon API" }
  end
end