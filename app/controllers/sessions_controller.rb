class SessionsController < ApplicationController
  def new
    @user = User.new
    render "sign-in-page"
  end

  # Экшен для регистрации (уже существующий)
  def create
    login_value = params[:user][:login]
    
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

  # НОВЫЙ экшен для авторизации (входа)
  def login
    # Ищем пользователя по username или по email
    user = User.find_by(username: params[:login]) || User.find_by(email: params[:login])

    # Проверяем, существует ли пользователь и подходит ли пароль
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id # Сохраняем сессию
      redirect_to root_path, notice: "Вы успешно вошли!"
    else
      # Если данные неверны, создаем пустой объект для формы и выводим ошибку
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
