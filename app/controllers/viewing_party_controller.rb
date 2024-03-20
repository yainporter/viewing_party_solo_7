class ViewingPartyController < ApplicationController
  def new
    @facade = MovieFacade.new(params)
    @viewing_party = ViewingParty.new
  end

  def create
    viewing_party = ViewingParty.new(viewing_party_params)
    if viewing_party.save
      UserParty.create!(user_id: params[:user_id], viewing_party_id: viewing_party.id, host: true)
      params[:viewing_party][:user_ids].each do |user_id|
        UserParty.create!(user_id: user_id, viewing_party_id: viewing_party.id, host: false) if user_id.to_i != 0
      end
      redirect_to user_path(params[:user_id])
    else
      flash[:alert] = "There was an error, try again"
      render :new
    end
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:duration, :date, :start_time)
  end
end
