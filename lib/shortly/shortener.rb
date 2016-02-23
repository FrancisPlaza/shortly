module Shortly
  class Shortener

    def self.shorten(url, vanity=nil)
      if vanity
        Shortly::ShortUrl.create({shortcode: vanity, url: url})
      else
        begin
          shortcode = StringRandom.random_regex('[0-9a-zA-Z_]{6}')
        end while Shortly::ShortUrl.find(shortcode: shortcode)
        Shortly::ShortUrl.create({shortcode: shortcode, url: url})
      end
    end
  end
end