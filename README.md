# TranslationEngine

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_translation_engine', github: 'camsys/simple_translation_engine'
```

And then execute:

    $ bundle

## Usage
### For a fresh install
1. rake translation_engine:install (this will install the necessary database tables)
1. create a locale loader rake task based on the sample file in https://github.com/camsys/translation_engine/tree/master/lib/tasks
1. To enable editing in your app, mount the translation_engine routes in your routes.rb file: mount TranslationEngine::Engine => "/translation_engine"
### For those who are already using a database back-end for translations
1. rake translation_engine:implement_new_database_schema will update your database if you already have a basic translations table
1. rake translation_engine:migrate_existing_translation_data will migrate your data into the new schema

## Contributing

1. Fork it ( https://github.com/[my-github-username]/translation_engine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request