package :postgres, :provides => :database do
  description 'PostgreSQL database'
  apt %w( postgresql postgresql-client libpq-dev )
  
  verify do
    has_executable 'psql'
  end

  optional :postgresql_driver
end
 
package :postgresql_driver, :provides => :ruby_database_driver do
  description 'Ruby PostgreSQL database driver'
  gem 'postgres'
  
  verify do
    has_gem 'postgres'
  end
  
  requires :ruby_enterprise
end
