require 'sequel'
require 'sequel/extensions/migration'
require './app.rb'

namespace :db do
  desc "Migrate the database through scripts in db/migrations."
  task :migrate do
    Sequel.extension :migration
    Sequel::Migrator.run(DB, 'db/migrations', use_transactions: true)
    puts "Migrations are up to date"
  end
end
