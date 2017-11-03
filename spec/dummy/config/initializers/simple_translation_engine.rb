SimpleTranslationEngine.configure do |config|
  
  # Only show Translation Keys namespaced under "global" or "pages"
  config.visible_key_scope = lambda {
    where("name LIKE ? OR name LIKE ?", "global.%", "pages.%")
  }
  
  # Hide any translation keys with "REFERNET" in the name
  config.hidden_key_scope = lambda {
    where("name ILIKE ?", "%REFERNET%")
  }
  
end
