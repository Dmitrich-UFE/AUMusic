class SessionsController < ApplicationController
  def new
    # Здесь рендерится вьюшка sign-in-page.html.erb
    render "sign-in-page"
  end
end
