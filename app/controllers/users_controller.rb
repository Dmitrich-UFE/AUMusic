class UsersController < ApplicationController
   helper_method :format_subscribers_count

 
    def show
    @user = User.find_by!(username: params[:username].downcase)
    @is_own_profile = logged_in? && (current_user.id == @user.id)

    unless @is_own_profile
      @albums = @user.artist ? @user.artist.albums.where(visibility: "public").order(created_at: :desc) : Album.none
      @singles = @user.tracks.where(visibility: "public", album_id: nil).includes(:artists).order(created_at: :desc)
      @playlists = @user.playlists.where(visibility: "public").order(created_at: :desc)
      @is_subscribed = logged_in? ? current_user.subscribed_to?(@user) : false
    end

  end


  private

  def format_subscribers_count(count)
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
end
