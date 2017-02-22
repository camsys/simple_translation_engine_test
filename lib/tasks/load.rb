require 'rake'
require 'active_record'

namespace :simple_translation_engine do

  class Hash
    def each_with_parents(parents=[], &blk)
      each do |k, v|
        Hash === v ? v.each_with_parents(parents + [k], &blk) : blk.call([parents + [k], v])
      end
    end
  end

  desc "Load database translations from config/locales/*.yml files"
  task :update => :environment do

    Rake::Task['simple_translation_engine:load_locales'].invoke

    locales_directory = Rails.root.to_s + "/config/locales/"

    Dir.foreach(locales_directory) do |filename|
      unless filename == "." || filename == ".."
        puts "Loading locale file #{filename}"
        y = YAML.load_file(locales_directory + filename)
        failed = success = skipped = 0

        y.each_with_parents do |parents, v|
          locale = parents.shift
          locale = Locale.find_or_create_by(name: locale)

          if v.is_a? Array
            translation_key_name = parents.join('.')
            translation_value = v.join(',')
            translation_key = TranslationKey.find_or_create_by!(name: translation_key_name)

            #Check if translation exists.  DO NOT overwrite existing translations.
            existing_translation = Translation.where("translation_key_id = ? AND locale_id = ?", translation_key.id, locale.id)

            if existing_translation.count == 0
              new_translation = Translation.new
              new_translation.translation_key_id = translation_key.id
              new_translation.locale_id = locale.id
              new_translation.value = translation_value
              new_translation.save!
              new_translation.id.nil? ? failed += 1 : success += 1
            else
              skipped += 1
            end

          else
            translation_key_name = parents.join('.')
            translation_value = v
            translation_key = TranslationKey.find_or_create_by!(name: translation_key_name)

            #Check if translation exists.  DO NOT overwrite existing translations.
            existing_translation = Translation.where("translation_key_id = ? AND locale_id = ?", translation_key.id, locale.id)

            if existing_translation.count == 0
              new_translation = Translation.new
              new_translation.translation_key_id = translation_key.id
              new_translation.locale_id = locale.id
              new_translation.value = translation_value
              new_translation.save!
              new_translation.id.nil? ? failed += 1 : success += 1
            else
              skipped += 1
            end
          end # v.is? Array 
        
        end # y.each 
        puts "Read #{success+failed} keys, #{success} successful, #{failed} failed, #{skipped} skipped"
      end # unless filename
    end # Dir.foreach
  end #load_locales

  desc "Sync Available Locales"
  task :load_locales => :environment do

    puts 'Updating the available locales to ' + I18n.available_locales.to_s
    #Make sure that all locales are created
    I18n.available_locales.each do |locale|
      Locale.where(name: locale).first_or_create
    end

    #Delete an locales not in the available locales
    Locale.where.not(name: I18n.available_locales).each do |locale|
      locale.delete
    end
  end
end #simple_translation_engine