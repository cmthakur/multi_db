available_models = [{name: 'Book', table_name: 'books'}]

Database.where({}).each do |db|
  subdomain = db.name
  available_models.each do |model_attrs|
    model = model_attrs[:name]
    table_name = model_attrs[:table_name]

    model_klass = Object.const_get(model)
    new_inherit_model = "#{subdomain.camelcase}#{model}"
    Object.const_set(new_inherit_model, Class.new(model_klass) {})
    new_inherit_model.constantize.table_name = table_name

    new_inherit_model.constantize.establish_connection Proc.new {
      config = YAML::load(File.open(File.join( Rails.root,'config','database.yml')))[ENV['ENV'] || 'development']
      db_name = subdomain
      config.merge('database' => db_name)
    }.call
  end
end
