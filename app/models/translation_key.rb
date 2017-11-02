class TranslationKey < ActiveRecord::Base

  has_many :translations, :dependent => :delete_all

  scope :hidden,  -> { where("name like ?", "REFERNET_%") } #Filter out REFERNET Translations
  scope :not_hidden, -> { where.not(id: hidden) }

  self.primary_key = :id 
  validates :name, length: { maximum: 255 }

  def translation(locale)
    self.translations.find_by(locale: Locale.of(locale)) # Locale.of converts the param from a string/symbol to Locale if necessary
  end
  
  # Builds a hash of all translation keys and values for the given locale
  def self.locale_hash(locale)
    self.all.map do |tkey|
      [ tkey.name, tkey.translation(Locale.of(locale)).try(:value) ]
    end.to_h
  end

end
