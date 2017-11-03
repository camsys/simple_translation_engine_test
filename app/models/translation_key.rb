class TranslationKey < ActiveRecord::Base

  has_many :translations, :dependent => :delete_all
    
  scope :visible, -> { 
    where(id: visible_include)
    .where.not(id: visible_exclude)
  }
  scope :unhidden, -> { where(id: visible) } # unhidden is an alias for visible
  scope :hidden, -> { where.not(id: visible)} # hidden is just all the keys not set to visible 
  
  # Create some helper scopes from the configured visible and hidden key scopes
  scope :visible_include, SimpleTranslationEngine.configuration.visible_key_scope
  scope :visible_exclude, SimpleTranslationEngine.configuration.hidden_key_scope

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
