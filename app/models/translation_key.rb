class TranslationKey < ActiveRecord::Base

  has_many :translations, :dependent => :delete_all

  self.primary_key = :id 
  validates :name, length: { maximum: 255 }

  def translation locale
    self.translations.find_by(locale: locale)
  end

end