class SessionsController < ApplicationController
  def new
    @user = User.new
    render "sign-in-page"
  end

  # Экшен для регистрации (уже существующий)
  def create
    login_value = params[:user][:login].to_s.strip.downcase
    
    @user = User.new(
      username: login_value,
      email: login_value.include?("@") ? login_value : "#{login_value}@example.com",
      password: params[:user][:password],
      password_confirmation: params[:user][:password_confirmation]
    )

    if @user.save
      session[:user_id] = @user.id 
      redirect_to root_path, notice: "Регистрация успешна!"
    else
      render "sign-in-page", status: :unprocessable_entity
    end
  end

  # Авторизация (Вход)
  def login
    # ВАЖНО: Принудительно переводим введенный логин в нижний регистр
    login_value = params[:login].to_s.strip.downcase

    # Ищем пользователя в PostgreSQL (теперь поиск гарантированно совпадет)
    user = User.find_by(username: login_value) || User.find_by(email: login_value)

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Вы успешно вошли!"
    else
      @user = User.new
      flash.now[:alert] = "Неверный никнейм/email или пароль"
      render "sign-in-page", status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Вы вышли из системы"
  end
end
