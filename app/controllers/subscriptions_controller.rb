class SubscriptionsController < ApplicationController
  before_action :require_login

  def toggle
    author = User.find_by!(username: params[:username].downcase)
    return head :bad_request if author == current_user

    sub = current_user.active_subscriptions.find_by(author: author)
    if sub
      sub.destroy
      subscribed = false
    else
      current_user.active_subscriptions.create(author: author)
      subscribed = true
    end

    render json: {
      subscribed: subscribed,
      subscribers_count: author.subscribers.count
    }
  end

  private

  def require_login
    head :unauthorized unless logged_in?
  end
end
