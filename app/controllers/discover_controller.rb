class DiscoverController < ApplicationController
  def index
    @user = User.find(current_user.id)
  end
end
