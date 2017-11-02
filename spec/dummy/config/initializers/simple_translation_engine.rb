SimpleTranslationEngine.configure do |config|
  puts "CONFIGURING!"
  config.hidden_keys = ["REFERNET", "test"]
  puts "CONFIGURED", config.hidden_keys
end
