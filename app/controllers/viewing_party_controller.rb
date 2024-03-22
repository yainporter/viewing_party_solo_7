class ViewingPartyController < ApplicationController
  def new
    # try passing only 1 param, not the full params
    @facade = MovieFacade.new(params[:movie_id], params[:user_id])
    @viewing_party = ViewingParty.new
    @users = User.all_but(params[:user_id])
  end

  def create
    viewing_party = ViewingParty.new(viewing_party_params)
    viewing_party.update(movie_id: params[:movie_id])

    if viewing_party.save && !user_party_ids[:user_ids].nil?
      new_user_parties(viewing_party)

      redirect_to user_path(params[:user_id])
    else
      flash[:alert] = "You need to invite other users, try again"

      redirect_to  new_user_movie_viewing_party_path
    end
  end

  def show
    @facade = MovieFacade.new(params[:movie_id])
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:duration, :date, :start_time)
  end

  def new_user_parties(viewing_party)
    user_party_ids[:user_ids].map { |user_id| viewing_party.user_parties.create(user_id:, host: false) }
    viewing_party.user_parties.create(user_id: params[:user_id], host: true)
  end

  def user_party_ids
    params.require(:viewing_party).permit(user_ids: [])
  end
end
