class TrackReactionsChannel < ApplicationCable::Channel
  def subscribed
    # Подписываем клиента на поток конкретного трека
    if params[:track_id].present?
      stream_from "track_reactions_#{params[:track_id]}"
    end
  end

  def unsubscribed
    # Очистка при отключении
  end
end
