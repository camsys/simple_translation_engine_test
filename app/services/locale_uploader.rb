# Builds translations for a given locale, based on an uploaded JSON file
class LocaleUploader
  attr_reader :locale, :translations_hash
  
  def initialize(locale=I18n.default_locale, file=nil)
    @locale = locale
    @translations_hash = flat_hash_from_json_file(read(file))
  end
  
  # Builds translations objects from the translations hash. 
  # Returns true if all builds were successful, false if not.
  def build_translations
    return false unless @translations_hash # Return false if parser could not find valid JSON
    @translations_hash.map do |key, translation|
      TranslationKey.find_or_create_by(name: key) and
      SimpleTranslationEngine.set_translation(@locale, key, translation)
    end.all?
  end
  
  # Extracts data from the uploaded file; method depends on file object type
  def read(file)
    if file.respond_to?(:read)
      return file.read
    elsif file.respond_to?(:path)
      return File.read(file.path)
    else
      Rails.logger.error "Bad file_data: #{file.class.name}: #{file.inspect}"
      return "{}"
    end
  end
  
  # Parses a JSON file and returns a flatten hashed, with each key as the full path to its value
  def flat_hash_from_json_file(file_data)
    begin
      JSON.parse(file_data).path_flatten
    rescue JSON::ParserError
      nil # Return nil if JSON is invalid
    end
  end  
  
end


# This module is for including in the Hash class, giving it a new method to flatten
# a multi-level nested hash into a single-level hash, where each key is
# the full path of the keys to get to that value.
# e.g. { a: { b: 2 }, c: 3 }.path_flatten => { "a.b" => 2, "c" => 3 }
module PathFlattenHash
  
  def path_flatten(prefix=nil)
    flattened_hash_array = self.flat_map do |k, v|
      new_prefix = [prefix, k].compact.join(".")
      if v.is_a?(Hash)
        next v.path_flatten(new_prefix)
      else
        next [ [new_prefix, v] ]
      end
    end
    
    prefix.present? ? flattened_hash_array : flattened_hash_array.to_h
  end
  
end

Hash.include(PathFlattenHash)
