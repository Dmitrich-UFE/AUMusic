class TracksController < ApplicationController
  #before_action :require_login
  #before_action :require_musician_or_owner

  before_action :require_login, except: [:show, :stats]
  before_action :require_musician_or_owner, except: [:show, :stats]


  def new
    @track = Track.new
  end


  def create
    coauthor_names = track_params[:coauthors] || []
    clean_params = track_params.except(:coauthors)

    # Привязываем трек к текущему пользователю по его ID
    @track = current_user.tracks.build(clean_params)
    @track.duration = 180 if @track.respond_to?(:duration)

    if @track.save
      main_artist = current_user.artist || current_user.create_artist!(name: current_user.username)
      @track.artists << main_artist

      coauthor_names.each do |name|
        user = User.find_by(username: name.downcase)
        next unless user

        artist = user.artist || user.create_artist!(name: user.username)
        @track.artists << artist unless @track.artists.include?(artist)
      end

      redirect_to root_path, notice: "Композиция «#{@track.title}» успешно опубликована!"
    else
      flash.now[:alert] = "Не удалось опубликовать композицию."
      render :new, status: :unprocessable_entity
    end
  end

  def stats
    track = Track.find(params[:id])
    return head :forbidden unless track.accessible_by?(current_user)

    render json: {
      likes_count: track.likes_count,
      comments_count: track.comments.count,
      user_reaction: logged_in? ? current_user.reactions.find_by(track: track)&.kind : nil
    }
  end

  def show
    @track = Track.find(params[:id])
    unless @track.accessible_by?(current_user)
    redirect_to root_path, alert: "Этот трек является приватным."
  end

  private

  def track_params
    params.require(:track).permit(:title, :description, :cover, :audio, :visibility, coauthors: [])
  end


  def require_login
    unless logged_in?
      redirect_to root_path, alert: "Необходимо войти в аккаунт."
    end
  end

  def require_musician_or_owner
    unless current_user.can_upload_music?
      redirect_to root_path, alert: "У вас нет прав для загрузки музыки."
    end
  end

end

  
end
