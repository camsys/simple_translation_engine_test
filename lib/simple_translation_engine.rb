require "simple_translation_engine/version"
require 'pg'
require 'simple_form'

#refactor these includes at some point, if possible
#require 'tasks/database_tasks'
require 'tasks/install'
require 'tasks/load'

module SimpleTranslationEngine

  class Engine < ::Rails::Engine

    engine_name 'simple_translation_engine'
    
  end

  def self.translate(locale_param, key_param, options={})
    locale = Locale.find_by(name: locale_param)
    unless locale
      return "missing locale #{locale_param}"
    end
    key = TranslationKey.find_by(name: key_param)
    unless key
      return "missing key #{key_param}"
    end

    translation = Translation.find_by(locale: locale, translation_key: key)
    return translation.nil? ? "missing translation #{locale.name}:#{key.name}" : translation.value 
  end

  def self.set_translation(locale_param, key_param, value)
    locale = Locale.find_by(name: locale_param)
    unless locale
      return false
    end 
    key = TranslationKey.where(name: key_param).first_or_create
    translation = Translation.where(locale: locale, translation_key: key).first_or_create
    translation.value = value
    return translation.save 
  end
  
  
  ### CONFIGURATION ###
  # Expose a Configuration object to including application
  # see http://ndlib.github.io/practices/exposing-configuration-options-in-rails-engines/
  
  # This describes the Configuration object that will be passed to the parent app.
  class Configuration
    attr_accessor :visible_key_scope, :hidden_key_scope
    
    def initialize
      @visible_key_scope = default_visible_key_scope
      @hidden_key_scope = default_hidden_key_scope
    end
    
    private
    
    # By default, all translation keys are visible
    def default_visible_key_scope
      lambda { all }
    end
    
    # By default, no translation keys are hidden
    def default_hidden_key_scope
      lambda { none }
    end
  end
  
  class << self
    attr_writer :configuration
  end

  module_function
  
  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield(configuration)
  end
  
end
