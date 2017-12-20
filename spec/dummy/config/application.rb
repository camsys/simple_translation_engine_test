require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "simple_translation_engine"

module Dummy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    
    config.i18n.available_locales = [:en, :es, :fr, :hi, 'zh-CN'] # english, spanish, french, hindi, mandarin chinese
end
