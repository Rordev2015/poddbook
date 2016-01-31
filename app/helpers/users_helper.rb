module UsersHelper
    # Returns the gravatar for the given user.
    def gravatar_for(user, options = { size: 80 } )
        gravatar_id = Digest::MD5::hexdigest(user.email)
        size = options[:size]
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
        image_tag(gravatar_url, alt: user.f_name, class: "gravatar")
    end
end