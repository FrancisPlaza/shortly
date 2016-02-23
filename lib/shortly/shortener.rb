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

    def self.redirect(shortcode)
      short_url = Shortly::ShortUrl.find(shortcode: shortcode)
      raise Shortly::ShortlyError.new("The shortcode cannot be found " \
        "in the system.", 404) if short_url.blank?
      short_url.update_fields({redirect_count: short_url.redirect_count + 1,
        updated_at: Time.now.utc}, [:redirect_count, :updated_at])
    end

    def self.stats(shortcode)
      short_url = Shortly::ShortUrl.find(shortcode: shortcode)
      raise Shortly::ShortlyError.new("The shortcode cannot be found " \
        "in the system.", 404) if short_url.blank?
      { startDate: short_url.created_at,
        lastSeenDate: (short_url.updated_at if short_url.redirect_count > 0),
        redirectCount: short_url.redirect_count }.reject{ |k,v| v.nil? }
    end
  end
end