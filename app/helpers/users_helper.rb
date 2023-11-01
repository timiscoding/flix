module UsersHelper
  def profile_image(user, size=80)
    image_tag("http://secure.gravatar.com/avatar/#{user.gravatar_id}?s=#{size}")
  end
end
