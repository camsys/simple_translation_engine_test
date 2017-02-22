class Locale < ActiveRecord::Base

  validates :name, length: { maximum: 255 }

end