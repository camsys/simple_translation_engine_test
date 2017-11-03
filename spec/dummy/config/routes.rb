Rails.application.routes.draw do
  mount SimpleTranslationEngine::Engine => "/simple_translation_engine"
end
