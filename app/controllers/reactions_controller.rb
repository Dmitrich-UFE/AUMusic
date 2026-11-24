class ReactionsController < ApplicationController
  before_action :require_login

  def toggle
    track = Track.find(params[:track_id])
    return head :forbidden unless track.accessible_by?(current_user)
    
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

    
    likes_count = track.likes_count
    ActionCable.server.broadcast("track_reactions_#{track.id}", { likes_count: likes_count })

    render json: {
      user_reaction: current_user.reactions.find_by(track: track)&.kind,
      likes_count: likes_count
    }
  end


  private

  def require_login
    head :unauthorized unless logged_in?
  end
end
