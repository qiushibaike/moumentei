if Rails.env.test? 
  config = Rails.configuration.database_configuration[Rails.env]
  if config['adapter'] =~ /sqlite/ and config['database'] == ':memory:'
    load_schema = lambda {
      # use db agnostic schema by default
      # ActiveRecord::Migrator.up('db/migrate') # use migrations
      load Rails.root.join('db/schema.rb')
    }
    #load_schema.call
    silence_stream(STDOUT, &load_schema)
  end
end