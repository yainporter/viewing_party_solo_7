class ViewingPartyController < ApplicationController
  def new
    @facade = MovieFacade.new(params)
  end

  def create

  end
end
