module DatabaseManipulator
  def self.perform_migration(databases=nil)
    if databases.blank?
      ActiveRecord::Base.establish_connection default_config
      databases = Database.where({}).pluck(:name)
      ActiveRecord::Base.connection.disconnect!
    end

    databases = Array.wrap(databases)
    create_database(databases)
    migrate(databases)
  end

  def self.create_database(databases=[])
    admin_config = default_config.merge({'database' => 'postgres', 'schema_search_path' => 'public'})
    ActiveRecord::Base.establish_connection admin_config
    databases.each do |db|
      ActiveRecord::Base.connection.create_database(db)
    rescue => e
      puts e.inspect
    end

    ActiveRecord::Base.connection.disconnect!
  end

  def self.migrate(databases=[])
    databases.each do |db|
      ActiveRecord::Base.establish_connection default_config.merge('database' => db)
      puts "Performing migration on #{db}"
      ActiveRecord::Migrator.migrate("db/migrate/individual/")
      ActiveRecord::Base.connection.disconnect!
    end
  end

  private

  def self.default_config
    YAML::load(File.open(File.join( Rails.root,'config','database.yml')))[ENV['ENV'] || 'development']
  end
end
