class TranslationKey < ActiveRecord::Base

  has_many :translations, :dependent => :delete_all

  scope :hidden,  -> { where("name REGEXP ?", "^REFERNET_"} #Filter our REFERNET Translations
  scope :not_hidden, -> { where.not(id: hidden) }

  self.primary_key = :id 
  validates :name, length: { maximum: 255 }

  def translation locale
    self.translations.find_by(locale: locale)
  end

end