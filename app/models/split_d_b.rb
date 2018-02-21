class SplitDB < ActiveRecord::Base
  # puts ENV['db_name']
  # establish_connection Proc.new {
  #   config = YAML::load(File.open(File.join( Rails.root,'config','database.yml')))[ENV['ENV'] || 'development']
  #   db_name = ENV['db_name']
  #   config.merge('database' => db_name)
  # }.call

  self.abstract_class = true
end