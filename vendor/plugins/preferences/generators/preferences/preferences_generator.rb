class PreferencesGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template '001_create_preferences.rb', 'db/migrate', :migration_file_name => 'create_preferences'
    end
  end
end
