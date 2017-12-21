require 'rake'
require 'active_record'

namespace :simple_translation_engine do
  
  # Translates all keys into the given language.
  # Requires a target_lang as first param -- 2-digit locale code (e.g. 'es', 'fr')
  # Optional second param is source locale... English ('en') by default
  # Optional third param is a flag for overwriting existing translations.
    # setting 3rd param to "true" or "overwrite" will translate all keys regardless
    # of whether or not a translation already exists in the target locale.
  desc "Translates all keys from english to the target language"
  task :translate, [:target_lang, :source_lang, :google_api_key, :overwrite] => :environment do |t,args|
    @target_lang = args[:target_lang]
    @source_lang = args[:source_lang].present? ? args[:source_lang] : I18n.default_locale
    @target_locale = Locale.of(@target_lang)
    @source_locale = Locale.of(@source_lang)
    @google_api_key = args[:google_api_key] if args[:google_api_key].present? 
    @overwrite = (args[:overwrite] == "true" || args[:overwrite] == "overwrite")
    @translator = (@google_api_key ? GoogleTranslator.new(@google_api_key) : DummyTranslator.new)
                  .from(@source_lang).to(@target_lang)
    
    puts "Attempting to translate all keys from #{@source_lang} to #{@target_lang} using #{@translator.class}..."
    
    if @source_locale.untranslated_keys.count > 0
      puts "Skipping #{@source_locale.untranslated_keys.count} keys because no source translation exists."
    end
    
    unless @overwrite
      puts "Skipping #{@source_locale.translated_keys.translated_into(@target_lang).count} keys because target translation already exists."
    end
        
    puts
    puts "Translating..."
    
    # For all keys with a translation in the source lang but that are missing
    # a translation in the target lang, translate them into the target lang
    # and set those translations
    keys_to_translate = @source_locale.translated_keys
    
    # Unless overwrite flag is set, only translate untranslated keys
    keys_to_translate = keys_to_translate.not_translated_into(@target_lang) unless (@overwrite)

    translation_count = keys_to_translate.each do |tkey|
      source_translation = SimpleTranslationEngine.translate(@source_locale, tkey.name).to_s
      target_translation = @translator.translate(source_translation)
      SimpleTranslationEngine.set_translation(@target_locale, tkey.name, target_translation)
      puts "Translated '#{source_translation}' as '#{target_translation}'"
    end.count
    
    puts "* Successfully translated #{translation_count} keys *"
    
  end
  
  desc "Translates all keys from the passed locale to all other locales"
  task :translate_everything, [:source_lang, :google_api_key, :overwrite] => :environment do |t,args|
    @source_lang = (args[:source_lang].present? ? args[:source_lang] : I18n.default_locale).try(:to_sym)
    
    locales_to_translate = I18n.available_locales.reject {|l| l == @source_lang }
    puts
    puts "*** TRANSLATING ***"
    puts
    puts "Translating all keys for the following languages: #{locales_to_translate.join(', ')}"
    puts
    
    locales_to_translate.each do |target_lang|
      unless Locale.of(target_lang)
        puts
        puts "Skipping #{target_lang} because locale has not been loaded. Run load_locales and try again."
        next
      end
      task = Rake::Task["simple_translation_engine:translate"]
      task.invoke(target_lang, @source_lang, args[:google_api_key], args[:overwrite])
      task.reenable
    end
    
    puts
    puts "*** TRANSLATION COMPLETE ***"
    puts
    
  end
  
  
end
