module Shortly
  class Shortener

    def self.shorten(url)
      shortcode = StringRandom.random_regex('[0-9a-zA-Z_]{6}')
    end
  end
end