module Shortly
  class ShortUrl < Sequel::Model
    set_allowed_columns  :url, :shortcode

    def self.redirect(shortcode)
      short_url = find(shortcode: shortcode)
      raise Shortly::ShortlyError.new("The shortcode cannot be found " \
        "in the system.", 404) if short_url.blank?
      short_url.update_fields({redirect_count: short_url.redirect_count + 1,
        updated_at: Time.now.utc}, [:redirect_count, :updated_at])
    end

    def before_create
      self.created_at ||= Time.now.utc
      self.updated_at ||= Time.now.utc
      super
    end
  end
end