class TranslationKeysController < ApplicationController
  
  def destroy
    translation_key = TranslationKey.find(params[:id])
    translation_key.destroy
    flash[:success] = "Translation Removed"
    redirect_to simple_translation_engine.translations_path
  end

end