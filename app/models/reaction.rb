class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :track

  # Разрешаем только два типа записей
  validates :kind, inclusion: { in: %w[like dislike], message: "Недопустимый тип реакции" }
  
  # Валидация уникальности пары на уровне Rails
  validates :user_id, uniqueness: { scope: :track_id, message: "Вы уже оставили реакцию на этот трек" }

  # Триггеры: срабатывают автоматически после записи или удаления из PostgreSQL
  after_commit :broadcast_reaction_stats, on: [:create, :update, :destroy]

  private

  def broadcast_reaction_stats
    # Отправляем обновленные данные в WebSocket-канал конкретного трека
    ActionCable.server.broadcast("track_reactions_#{track_id}", {
      likes_count: track.likes_count,
      dislikes_count: track.dislikes_count
    })
  end
end
