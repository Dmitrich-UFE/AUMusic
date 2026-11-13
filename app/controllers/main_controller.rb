class MainController < ApplicationController
  def startpage
    @per_page = 40
    @page = params[:page].to_i > 0 ? params[:page].to_i : 1
    
    # Фильтруем треки через scope с проверкой по current_user.id
    @tracks = Track.visible_for(current_user)
                   .includes(:artists)
                   .order(created_at: :desc)
                   .limit(@per_page)
                   .offset((@page - 1) * @per_page)

    # Если это AJAX-запрос от бесконечного скролла, отдаем только карточки без шапки
    if request.xhr?
      render partial: "track_cards", locals: { tracks: @tracks }
    end
  end
end