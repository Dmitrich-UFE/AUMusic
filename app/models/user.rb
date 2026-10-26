class User < ApplicationRecord
  # Отключаем встроенную валидацию присутствия пароля (validations: false),
  # но оставляем само хэширование, чтобы написать кастомную русскую валидацию
  has_secure_password validations: false

  validates :username, presence: { message: "Никнейм не может быть пустым" },
                       uniqueness: { message: "Этот никнейм уже занят" },
                       length: { minimum: 3, message: "Никнейм должен быть не менее 3 символов" }

  validates :email, presence: { message: "Email не может быть пустым" },
                    uniqueness: { message: "Этот Email уже зарегистрирован" },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "Некорректный формат Email" }

  # Наша русская валидация для пароля
  validates :password, presence: { message: "Пароль не может быть пустым" },
                       length: { minimum: 6, message: "Пароль должен быть не менее 6 символов" },
                       confirmation: { message: "Пароли не совпадают" },
                       on: :create # Проверять только при регистрации нового аккаунта
end
