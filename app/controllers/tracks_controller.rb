class TracksController < ApplicationController
  before_action :require_login
  before_action :require_musician_or_owner

  def new
    @track = Track.new
  end


  def create
    @track = Track.new(track_params)
  
    # Временно задаем базовую длительность, так как в форме этого поля нет
    @track.duration = 180 if @track.respond_to?(:duration)

    # Находим артиста текущего пользователя, чтобы сделать его главным автором
    artist = current_user.artist || current_user.create_artist!(name: current_user.username)

    if @track.save
      # Привязываем главного автора к треку
      @track.artists << artist
      redirect_to root_path, notice: "Композиция «#{@track.title}» успешно опубликована!"
    else
      flash.now[:alert] = "Не удалось опубликовать композицию."
      render :new, status: :unprocessable_entity
    end
  end


  private

  # Разрешаем принимать текстовые поля И файлы из формы
  def track_params
    params.require(:track).permit(:title, :description, :cover, :audio)
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
