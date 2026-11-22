class CommentsController < ApplicationController
  before_action :require_login, only: [:create, :toggle_like]

  def index
    track = Track.find(params[:track_id])
    return head :forbidden unless track.accessible_by?(current_user)

    root_comments = track.comments
                         .where(parent_id: nil)
                         .includes(:user, :comment_likes, replies: [:user, :comment_likes])
                         .sort_by { |c| -c.importance_score }

    total_count = track.comments.count

    render json: {
      total_count: total_count,
      total_count_formatted: format_compact_number(total_count),
      comments: root_comments.map { |c| serialize_comment(c, include_replies: true) }
    }
  end

  def create
    track = Track.find(params[:track_id])
    return head :forbidden unless track.accessible_by?(current_user)

    parent_id = params[:parent_id].presence
    if parent_id
      parent_comment = track.comments.find_by(id: parent_id)
      parent_id = parent_comment&.parent_id || parent_comment&.id
    end

    comment = track.comments.build(
      user: current_user,
      body: params[:body].to_s.strip,
      parent_id: parent_id
    )

    if comment.save
      total_count = track.comments.count
      render json: {
        total_count: total_count,
        total_count_formatted: format_compact_number(total_count),
        comment: serialize_comment(comment, include_replies: false)
      }, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def toggle_like
    comment = Comment.find(params[:id])
    return head :forbidden unless comment.track.accessible_by?(current_user)

    like = current_user.comment_likes.find_by(comment: comment)
    if like
      like.destroy
      liked = false
    else
      current_user.comment_likes.create(comment: comment)
      liked = true
    end

    likes_count = comment.comment_likes.count

    render json: {
      liked: liked,
      likes_count: likes_count,
      formatted_likes: format_compact_number(likes_count)
    }
  end


  def destroy
    comment = Comment.find(params[:id])
    return head :forbidden unless comment.user_id == current_user.id

    track = comment.track
    comment.destroy
    total_count = track.comments.count

    render json: {
      total_count: total_count,
      total_count_formatted: format_compact_number(total_count)
    }
  end


  

  private

  def require_login
    head :unauthorized unless logged_in?
  end

  def format_compact_number(count)
    if count >= 1_000_000_000
      "#{(count / 1_000_000_000.0).round(1).to_s.sub(/\.0$/, '')} млрд."
    elsif count >= 1_000_000
      "#{(count / 1_000_000.0).round(1).to_s.sub(/\.0$/, '')} млн."
    elsif count >= 1_000
      "#{(count / 1_000.0).round(1).to_s.sub(/\.0$/, '')} тыс."
    else
      count.to_s
    end
  end

  def serialize_comment(comment, include_replies: false)
    likes_count = comment.comment_likes.size

    data = {
      id: comment.id,
      parent_id: comment.parent_id,
      username: comment.user.username,
      avatar_url: comment.user.avatar.attached? ? rails_blob_path(comment.user.avatar, only_path: true) : nil,
      time_ago: format_comment_time(comment.created_at),
      body: comment.body,
      likes_count: likes_count,
      formatted_likes: format_compact_number(likes_count),
      liked_by_me: logged_in? ? comment.comment_likes.any? { |l| l.user_id == current_user.id } : false,
      can_delete: logged_in? && (comment.user_id == current_user.id)
    }

    if include_replies
      ordered_replies = comment.replies.sort_by(&:created_at)
      data[:replies] = ordered_replies.map { |r| serialize_comment(r, include_replies: false) }
    end

    data
  end

  def format_comment_time(time)
    diff = (Time.current - time).to_i

    if diff < 60
      "только что"
    elsif diff < 3600
      "#{diff / 60} мин. назад"
    elsif diff < 86_400
      "#{diff / 3600} ч. назад"
    elsif diff < 14 * 86_400
      "#{diff / 86_400} дн. назад"
    elsif time.year == Time.current.year
      time.strftime("%d/%m")
    else
      time.strftime("%d/%m/%Y")
    end
  end


  

end
