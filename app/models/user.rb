class User < ApplicationRecord
  # Отключаем встроенную валидацию присутствия пароля (validations: false),
  # но оставляем само хэширование, чтобы написать кастомную русскую валидацию
  has_secure_password validations: false
  has_one_attached :avatar
  has_one_attached :banner

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

  # Перечисление ролей (Enum)
  enum :role, { user: "user", musician: "musician", owner: "owner" }, default: "user"

  # Автоматически делаем первого пользователя Владельцем платформы
  before_create :make_first_user_owner
  before_validation :downcase_login_fields

  # Связи для обычных пользователей
  has_many :playlists, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy


  has_many :tracks, dependent: :destroy
  has_one :artist, dependent: :destroy
  has_many :albums, through: :artist
  has_many :playlists, dependent: :destroy

  # Подписки
  has_many :active_subscriptions, class_name: "Subscription", foreign_key: "subscriber_id", dependent: :destroy
  has_many :passive_subscriptions, class_name: "Subscription", foreign_key: "author_id", dependent: :destroy
  has_many :subscribers, through: :passive_subscriptions, source: :subscriber

  validates :bio, length: { maximum: 200 }, allow_blank: true

  def subscribed_to?(other_user)
    active_subscriptions.exists?(author_id: other_user.id)
  end

  # Связь для музыканта (у музыканта может быть профиль его группы/артиста)
  has_one :artist, dependent: :destroy

  # Проверка прав доступа (хелперы)
  def can_upload_music?
    musician? || owner?
  end

  def can_assign_roles?
    owner?
  end

  private

  def downcase_login_fields
    self.username = username.strip.downcase if username.present?
    self.email = email.strip.downcase if email.present?
  end

  def make_first_user_owner
    if User.count.zero?
      self.role = :owner
    end
  end                     
end
