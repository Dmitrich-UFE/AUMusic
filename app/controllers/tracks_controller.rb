class TracksController < ApplicationController
  # Проверяем авторизацию перед открытием формы создания
  before_action :require_login
  # Проверяем, имеет ли пользователь право загружать музыку (Музыкант или Владелец)
  before_action :require_musician_or_owner

  def new
    @track = Track.new
    # Рендерит ваш файл app/views/tracks/new.html.erb
  end

  def create
    # Здесь позже будет логика сохранения в PostgreSQL
  end

  private

  # Проверка: вошел ли пользователь вообще
  def require_login
    unless logged_in?
      redirect_to root_path, alert: "Для доступа к этой странице необходимо войти в аккаунт."
    end
  end

  # Проверка: есть ли у пользователя роль Музыканта или Владельца
  def require_musician_or_owner
    unless current_user.can_upload_music?
      redirect_to root_path, alert: "У вас нет прав для загрузки музыки."
    end
  end
end
