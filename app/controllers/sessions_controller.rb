class SessionsController < ApplicationController
  # Отображение формы
  def new
    @user = User.new
    render "sign-in-page"
  end

  # Обработка отправки формы
  def create
    # Поскольку в поле ввода у нас никнейм или email, мы запишем его и туда, и туда для валидации на данном этапе
    login_value = params[:user][:login]
    
    @user = User.new(
      username: login_value,
      email: login_value.include?("@") ? login_value : "#{login_value}@example.com", # Временная логика для email
      password: params[:user][:password],
      password_confirmation: params[:user][:password_confirmation]
    )

    if @user.save
      redirect_to root_path, notice: "Регистрация успешна!"
    else
      # Если валидация не прошла, рендерим страницу заново с сохраненными ошибками
      render "sign-in-page", status: :unprocessable_entity
    end
  end
end
