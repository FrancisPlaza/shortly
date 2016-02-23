module Shortly
  class Shortener

    def self.shorten(url, vanity=nil)
      begin
        unless url =~ /\A#{URI::regexp}\z/
          raise Shortly::ShortlyError.new(
              "url is invalid.", 422)
        end
        if !vanity.blank?
          unless vanity =~ /[0-9a-zA-Z_]{4,}/
            raise Shortly::ShortlyError.new(
              "The shortcode fails to meet the following regexp: " \
              "^[0-9a-zA-Z_]{4,}$.", 422)
          end
          Shortly::ShortUrl.create({shortcode: vanity, url: url})
        else
          begin
            shortcode = StringRandom.random_regex('[0-9a-zA-Z_]{6}')
          end while Shortly::ShortUrl.find(shortcode: shortcode)
          Shortly::ShortUrl.create({shortcode: shortcode, url: url})
        end
      rescue Sequel::UniqueConstraintViolation => e
        raise Shortly::ShortlyError.new("The desired shortcode is " \
          "already in use.", 409)
      end
    end
  end
end