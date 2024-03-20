class ViewingPartyController < ApplicationController
  def new
    @facade = MovieFacade.new(params)
    @viewing_party = ViewingParty.new
  end

  def create
    viewing_party = ViewingParty.new(viewing_party_params)
    if viewing_party.save
      require 'pry'; binding.pry
      viewing_party.create_user_parties(params)
      UserParty.create!(user_id: params[:user_id], viewing_party_id: viewing_party.id, host: false)
    else
      flash[:alert] = "There was an error, try again"
      render :new
    end
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:duration, :date, :start_time)
  end

  def create_user_parties
    require 'pry'; binding.pry
  end
end
