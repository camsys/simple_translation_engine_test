class Translation < ActiveRecord::Base

  belongs_to :locale
  belongs_to :translation_key
  
  # Gets all translations for a given locale. Accepts string, symbol, or Locale object
  scope :for_locale, -> (loc) { where(locale: Locale.of(loc)) }
    
  self.primary_key = :id 

  delegate :name, to: :translation_key, prefix: :key, allow_nil: true

  attr_reader :key

  def key
    @key || key_name
  end

end
