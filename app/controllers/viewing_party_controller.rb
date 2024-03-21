class ViewingPartyController < ApplicationController
  def new
    # try passing only 1 param, not the full params
    @facade = MovieFacade.new(params[:movie_id])
    @viewing_party = ViewingParty.new
    @users = User.all_but(params[:user_id])
  end

  def create
    viewing_party = ViewingParty.new(viewing_party_params)
    if viewing_party.save
      create_user_parties(viewing_party)

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

  def create_user_parties(viewing_party)
    filter_user_party_ids.map{ |user_id| viewing_party.user_parties.create(user_id:, host: false) }
    viewing_party.user_parties.create!(user_id: params[:user_id], host: true)
  end

  def user_party_ids
    params.require(:viewing_party).permit(user_ids: [])
  end

  def filter_user_party_ids
    user_party_ids[:user_ids].reject{|id| id == ""}
  end
end
