#class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
 # allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  #stale_when_importmap_changes
#end

class ApplicationController < ActionController::Base
  # Делаем методы доступными во вьюшках (HTML)
  helper_method :current_user, :logged_in?

  def current_user
    # Ищем пользователя в базе данных PostgreSQL только если есть сессия, и кэшируем результат
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end
end

