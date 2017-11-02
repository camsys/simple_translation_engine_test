class Locale < ActiveRecord::Base

  validates :name, length: { maximum: 255 }
  
  # Returns the locale object based on the passed param, either a string, symbol, or Locale
  def self.of(locale)
    locale.is_a?(Locale) ? locale : Locale.find_by(name: locale.to_s.downcase)
  end

end
