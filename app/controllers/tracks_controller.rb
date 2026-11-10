class TracksController < ApplicationController
  before_action :require_login
  before_action :require_musician_or_owner

  def new
    @track = Track.new
  end


    def create
    # Вырезаем соавторов из общих параметров перед инициализацией трека, 
    # так как в самой таблице tracks этого поля нет
    coauthor_names = track_params[:coauthors] || []
    clean_params = track_params.except(:coauthors)

    @track = Track.new(clean_params)
    @track.duration = 180 if @track.respond_to?(:duration) # Временная заглушка длительности

    if @track.save
      # 1. Привязываем главного автора (текущего пользователя)
      main_artist = current_user.artist || current_user.create_artist!(name: current_user.username)
      @track.artists << main_artist

      # 2. Привязываем соавторов из модального окна
      coauthor_names.each do |name|
        # Ищем пользователя по никнейму
        user = User.find_by(username: name.downcase)
        next unless user # Если пользователь не найден в БД, пропускаем

        # Находим его музыкальный профиль или создаем новый
        artist = user.artist || user.create_artist!(name: user.username)
        
        # Записываем связь в Many-to-Many таблицу track_artists в PostgreSQL
        @track.artists << artist unless @track.artists.include?(artist)
      end

      redirect_to root_path, notice: "Композиция «#{@track.title}» успешно опубликована!"
    else
      flash.now[:alert] = "Не удалось опубликовать композицию."
      render :new, status: :unprocessable_entity
    end
  end



  private

  # Разрешаем принимать текстовые поля И файлы из формы

  def track_params
    # Разрешаем принимать массив соавторов coauthors: []
    params.require(:track).permit(:title, :description, :cover, :audio, coauthors: [])
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
