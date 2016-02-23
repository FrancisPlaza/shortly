module Shortly
  class ShortUrl < Sequel::Model
    set_allowed_columns  :url, :shortcode

    def before_create
      self.created_at ||= Time.now.utc
      self.updated_at ||= Time.now.utc
      super
    end
  end
end