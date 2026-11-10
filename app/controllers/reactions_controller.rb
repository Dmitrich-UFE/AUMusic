class ReactionsController < ApplicationController
  before_action :require_login

    def toggle
    track = Track.find(params[:track_id])
    reaction = current_user.reactions.find_by(track: track)
    current_kind = nil

    if reaction
      if reaction.kind == params[:kind]
        reaction.destroy
      else
        reaction.update(kind: params[:kind])
        current_kind = params[:kind]
      end
    else
      current_user.reactions.create(track: track, kind: params[:kind])
      current_kind = params[:kind]
    end

    # Возвращаем текущий статус реакции пользователя для мгновенной локальной подмены
    render json: { user_reaction: current_kind }
  end


  private

  def require_login
    head :unauthorized unless logged_in?
  end
end
