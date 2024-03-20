class ViewingPartyController < ApplicationController
  def new
    @facade = MovieFacade.new(params)
    @viewing_party = ViewingParty.new
  end

  def create

  end
end
