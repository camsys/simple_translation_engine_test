class Locale < ActiveRecord::Base

  validates :name, length: { maximum: 255 }
  
  # All the translations for this locale
  has_many :translations
  
  # All the keys that have been translated for this locale
  has_many :translated_keys, through: :translations, source: :translation_key, class_name: "TranslationKey"
  
  # Returns the locale object based on the passed param, either a string, symbol, or Locale
  def self.of(locale)
    locale.is_a?(Locale) ? locale : Locale.find_by(name: locale.to_s)
  end
  
  # Returns a collection of all keys NOT translated into this locale
  def untranslated_keys
    TranslationKey.where.not(id: translated_keys.pluck(:id))
  end

end
