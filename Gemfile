source :rubygems

gemspec

gem 'dm-mapper', :path => '.'

gem 'adamantium', :github => 'dkubb/adamantium'
gem 'equalizer',  :github => 'dkubb/equalizer'

group :veritas do
  gem 'veritas',               :github => 'dkubb/veritas'
  gem 'veritas-sql-generator', :github => 'dkubb/veritas-sql-generator'
  gem 'veritas-do-adapter',    :github => 'dkubb/veritas-do-adapter'
end

group :mongo do
  gem 'mongo'
  gem 'bson_ext', :platforms => [ :mri ]
end

group :arel_engine do
  gem 'arel',                   :github => 'rails/arel'
  gem 'arel_do_engine',         :github => 'myabc/arel_do_engine', :branch => 'master'
end

group :arel_engine_activerecord do
  gem 'activerecord'
  gem 'pg', :platforms => :ruby
  gem 'activerecord-jdbcpostgresql-adapter', '>= 1.2.0', :platforms => :jruby
end

group :test do
  gem 'do_postgres', '~> 0.10.12'
  gem 'randexp'
  gem 'ruby-graphviz'
  gem 'virtus'
end

group :development do
  gem 'devtools', :github => 'datamapper/devtools'
  eval File.read('Gemfile.devtools')
end
