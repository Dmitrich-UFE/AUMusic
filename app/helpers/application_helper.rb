module ApplicationHelper
  def mask_username(username)
    return username if username.blank?
    
    length = username.length
    if length > 4
      "#{username[0..1]}**#{username[-2..-1]}"
    elsif length == 4
      "#{username[0]}**#{username[-1]}"
    else
      username # для совсем коротких имен
    end
  end
end
