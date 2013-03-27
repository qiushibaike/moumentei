if Rails.env.test?
  load_schema = lambda {
    # use db agnostic schema by default
    # ActiveRecord::Migrator.up('db/migrate') # use migrations
    load Rails.root.join('db/schema.rb')
  }
  silence_stream(STDOUT, &load_schema)
  
end