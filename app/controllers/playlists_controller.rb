class PlaylistsController < ApplicationController
  def show
    @playlist = Playlist.find(params[:id])

    # ПРОВЕРКА ДОСТУПА: Блокируем просмотр чужого приватного плейлиста по прямой ссылке
    unless @playlist.accessible_by?(current_user)
      redirect_to root_path, alert: "Доступ запрещен: этот плейлист является приватным."
    end
  end
end