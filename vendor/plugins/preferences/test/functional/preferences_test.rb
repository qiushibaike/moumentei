require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ModelPreferenceTest < ActiveRecord::TestCase
  def default_test
  end
  
  def teardown
    User.preference_definitions.clear
  end
end

class ModelWithoutPreferencesTest < ActiveRecord::TestCase
  def test_should_not_create_preference_definitions
    assert !Car.respond_to?(:preference_definitions)
  end
  
  def test_should_not_create_stored_preferences_association
    assert !Car.new.respond_to?(:stored_preferences)
  end
  
  def test_should_not_create_preference_scopes
    assert !Car.respond_to?(:with_preferences)
    assert !Car.respond_to?(:without_preferences)
  end
end

class PreferencesAfterFirstBeingDefinedTest < ModelPreferenceTest
  def setup
    User.preference :notifications
    @user = new_user
  end
  
  def test_should_create_preference_definitions
    assert User.respond_to?(:preference_definitions)
  end
  
  def test_should_create_preference_scopes
    assert User.respond_to?(:with_preferences)
    assert User.respond_to?(:without_preferences)
  end
  
  def test_should_create_stored_preferences_associations
    assert @user.respond_to?(:stored_preferences)
  end
end

class PreferencesAfterBeingDefinedTest < ModelPreferenceTest
  def setup
    @definition = User.preference :notifications
    @user = new_user
  end
  
  def test_should_raise_exception_if_invalid_options_specified
    assert_raise(ArgumentError) {User.preference :notifications, :invalid => true}
    assert_raise(ArgumentError) {User.preference :notifications, :boolean, :invalid => true}
  end
  
  def test_should_create_definition
    assert_not_nil @definition
    assert_equal 'notifications', @definition.name
  end
  
  def test_should_create_preferred_query_method
    assert @user.respond_to?(:preferred_notifications?)
  end
  
  def test_should_create_prefers_query_method
    assert @user.respond_to?(:prefers_notifications?)
  end
  
  def test_should_create_preferred_reader
    assert @user.respond_to?(:preferred_notifications)
  end
  
  def test_should_create_prefers_reader
    assert @user.respond_to?(:prefers_notifications)
  end
  
  def test_should_create_preferred_writer
    assert @user.respond_to?(:preferred_notifications=)
  end
  
  def test_should_create_prefers_writer
    assert @user.respond_to?(:prefers_notifications=)
  end
  
  def test_should_create_preferred_changed_query
    assert @user.respond_to?(:preferred_notifications_changed?)
  end
  
  def test_should_create_prefers_changed_query
    assert @user.respond_to?(:prefers_notifications_changed?)
  end
  
  def test_should_create_preferred_was
    assert @user.respond_to?(:preferred_notifications_was)
  end
  
  def test_should_create_prefers_was
    assert @user.respond_to?(:prefers_notifications_was)
  end
  
  def test_should_create_preferred_change
    assert @user.respond_to?(:preferred_notifications_change)
  end
  
  def test_should_create_prefers_change
    assert @user.respond_to?(:prefers_notifications_change)
  end
  
  def test_should_create_preferred_will_change
    assert @user.respond_to?(:preferred_notifications_will_change!)
  end
  
  def test_should_create_prefers_will_change
    assert @user.respond_to?(:prefers_notifications_will_change!)
  end
  
  def test_should_create_preferred_reset
    assert @user.respond_to?(:reset_preferred_notifications!)
  end
  
  def test_should_create_prefers_reset
    assert @user.respond_to?(:reset_prefers_notifications!)
  end
  
  def test_should_include_new_definitions_in_preference_definitions
    assert_equal e = {'notifications' => @definition}, User.preference_definitions
  end
end

class PreferencesByDefaultTest < ModelPreferenceTest
  def setup
    @definition = User.preference :notifications
    @user = new_user
  end
  
  def test_should_have_boolean_type
    assert_equal :boolean, @definition.type
  end
  
  def test_should_not_have_default_value
    assert_nil @definition.default_value
  end
  
  def test_should_only_have_default_preferences
    assert_equal e = {'notifications' => nil}, @user.preferences
  end
  
  def test_should_not_query_preferences_changed
    assert_equal false, @user.preferences_changed?
  end
  
  def test_should_not_query_group_preferences_changed
    assert_equal false, @user.preferences_changed?(:chat)
  end
  
  def test_should_not_have_preferences_changed
    assert_equal [], @user.preferences_changed
  end
  
  def test_should_not_have_group_preferences_changed
    assert_equal [], @user.preferences_changed(:chat)
  end
  
  def test_should_not_have_preference_changes
    assert_equal e = {}, @user.preference_changes
  end
  
  def test_should_not_have_group_preference_changes
    assert_equal e = {}, @user.preference_changes(:chat)
  end
end

class PreferencesWithCustomTypeTest < ModelPreferenceTest
  def setup
    @definition = User.preference :vehicle_id, :integer
    @user = new_user
  end
  
  def test_should_have_boolean_type
    assert_equal :integer, @definition.type
  end
  
  def test_should_not_have_default_value
    assert_nil @definition.default_value
  end
  
  def test_should_only_have_default_preferences
    assert_equal e = {'vehicle_id' => nil}, @user.preferences
  end
end

class PreferencesWithCustomDefaultTest < ModelPreferenceTest
  def setup
    @definition = User.preference :color, :string, :default => 'red'
    @user = new_user
  end
  
  def test_should_have_boolean_type
    assert_equal :string, @definition.type
  end
  
  def test_should_have_default_value
    assert_equal 'red', @definition.default_value
  end
  
  def test_should_only_have_default_preferences
    assert_equal e = {'color' => 'red'}, @user.preferences
  end
end

class PreferencesWithMultipleDefinitionsTest < ModelPreferenceTest
  def setup
    User.preference :notifications, :default => true
    User.preference :color, :string, :default => 'red'
    @user = new_user
  end
  
  def test_should_only_have_default_preferences
    assert_equal e = {'notifications' => true, 'color' => 'red'}, @user.preferences
  end
end

class PreferencesAfterBeingCreatedTest < ModelPreferenceTest
  def setup
    User.preference :notifications, :default => true
    @user = create_user
  end
  
  def test_should_not_have_any_stored_preferences
    assert @user.stored_preferences.empty?
  end
end

class PreferencesReaderTest < ModelPreferenceTest
  def setup
    User.preference :notifications, :default => true
    @user = create_user
  end
  
  def test_should_raise_exception_if_invalid_preference_read
    exception = assert_raise(ArgumentError) { @user.preferred(:invalid) }
    assert_equal 'Unknown preference: invalid', exception.message
  end
  
  def test_use_default_value_if_not_stored
    assert_equal true, @user.preferred(:notifications)
  end
  
  def test_should_use_group_default_value_if_not_stored
    User.preference :language, :string, :default => 'English', :group_defaults => {:chat => 'Latin'}
    assert_equal 'English', @user.preferred(:language)
  end
  
  def test_should_use_stored_value_if_stored
    create_preference(:owner => @user, :name => 'notifications', :value => false)
    assert_equal false, @user.preferred(:notifications)
  end
  
  def test_should_type_cast_based_on_preference_definition
    @user.write_preference(:notifications, 'false')
    assert_equal false, @user.preferred(:notifications)
  end
  
  def test_should_cache_stored_values
    create_preference(:owner => @user, :name => 'notifications', :value => false)
    assert_queries(1) { @user.preferred(:notifications) }
    assert_queries(0) { @user.preferred(:notifications) }
  end
  
  def test_should_not_query_if_preferences_already_loaded
    @user.preferences
    assert_queries(0) { @user.preferred(:notifications) }
  end
  
  def test_should_use_value_from_preferences_lookup
    create_preference(:owner => @user, :name => 'notifications', :value => false)
    @user.preferences
    
    assert_queries(0) { assert_equal false, @user.preferred(:notifications) }
  end
  
  def test_should_be_able_to_use_prefers_reader
    assert_equal true, @user.prefers_notifications
  end
  
  def test_should_be_able_to_use_preferred_reader
    assert_equal true, @user.preferred_notifications
  end
end

class PreferencesGroupReaderTest < ModelPreferenceTest
  def setup
    User.preference :notifications, :default => true
    @user = create_user
  end
  
  def test_should_use_default_value_if_not_stored
    assert_equal true, @user.preferred(:notifications, :chat)
  end
  
  def test_should_use_group_default_value_if_not_stored
    User.preference :language, :string, :default => 'English', :group_defaults => {:chat => 'Latin'}
    assert_equal 'Latin', @user.preferred(:language, :chat)
  end
  
  def test_should_use_stored_value_if_stored
    create_preference(:owner => @user, :group_type => 'chat', :name => 'notifications', :value => false)
    assert_equal false, @user.preferred(:notifications, :chat)
  end
  
  def test_should_cache_stored_values
    create_preference(:owner => @user, :group_type => 'chat', :name => 'notifications', :value => false)
    assert_queries(1) { @user.preferred(:notifications, :chat) }
    assert_queries(0) { @user.preferred(:notifications, :chat) }
  end
  
  def test_should_not_query_if_preferences_already_loaded
    @user.preferences(:chat)
    assert_queries(0) { @user.preferred(:notifications, :chat) }
  end
  
  def test_should_use_value_from_preferences_lookup
    create_preference(:owner => @user, :group_type => 'chat', :name => 'notifications', :value => false)
    @user.preferences(:chat)
    
    assert_queries(0) { assert_equal false, @user.preferred(:notifications, :chat) }
  end
  
  def test_should_be_able_to_use_prefers_reader
    assert_equal true, @user.prefers_notifications(:chat)
  end
  
  def test_should_be_able_to_use_preferred_reader
    assert_equal true, @user.preferred_notifications(:chat)
  end
end

class PreferencesARGroupReaderTest < ModelPreferenceTest
  def setup
    @car = create_car
    
    User.preference :notifications, :default => true
    @user = create_user
  end
  
  def test_use_default_value_if_not_stored
    assert_equal true, @user.preferred(:notifications, @car)
  end
  
  def test_should_use_stored_value_if_stored
    create_preference(:owner => @user, :group_type => 'Car', :group_id => @car.id, :name => 'notifications', :value => false)
    assert_equal false, @user.preferred(:notifications, @car)
  end
  
  def test_should_use_value_from_preferences_lookup
    create_preference(:owner => @user, :group_type => 'Car', :group_id => @car.id, :name => 'notifications', :value => false)
    @user.preferences(@car)
    
    assert_queries(0) { assert_equal false, @user.preferred(:notifications, @car) }
  end
  
  def test_should_be_able_to_use_prefers_reader
    assert_equal true, @user.prefers_notifications(@car)
  end
  
  def test_should_be_able_to_use_preferred_reader
    assert_equal true, @user.preferred_notifications(@car)
  end
end

class PreferencesQueryTest < ModelPreferenceTest
  def setup
    User.preference :language, :string
    @user = create_user
  end
  
  def test_should_raise_exception_if_invalid_preference_queried
    exception = assert_raise(ArgumentError) { @user.preferred?(:invalid) }
    assert_equal 'Unknown preference: invalid', exception.message
  end
  
  def test_should_be_true_if_present
    @user.preferred_language = 'English'
    assert_equal true, @user.preferred?(:language)
  end
  
  def test_should_be_false_if_not_present
    assert_equal false, @user.preferred?(:language)
  end
  
  def test_should_use_stored_value_if_stored
    create_preference(:owner => @user, :name => 'language', :value => 'English')
    assert_equal true, @user.preferred?(:language)
  end
  
  def test_should_cache_stored_values
    create_preference(:owner => @user, :name => 'language', :value => 'English')
    assert_queries(1) { @user.preferred?(:language) }
    assert_queries(0) { @user.preferred?(:language) }
  end
  
  def test_should_be_able_to_use_prefers_reader
    assert_equal false, @user.prefers_language?
  end
  
  def test_should_be_able_to_use_preferred_reader
    assert_equal false, @user.preferred_language?
  end
end

class PreferencesGroupQueryTest < ModelPreferenceTest
  def setup
    User.preference :language, :string
    @user = create_user
  end
  
  def test_should_be_true_if_present
    @user.preferred_language = 'English', :chat
    assert_equal true, @user.preferred?(:language, :chat)
  end
  
  def test_should_be_false_if_not_present
    assert_equal false, @user.preferred?(:language, :chat)
  end
  
  def test_should_use_stored_value_if_stored
    create_preference(:owner => @user, :group_type => 'chat', :name => 'language', :value => 'English')
    assert_equal true, @user.preferred?(:language, :chat)
  end
  
  def test_should_cache_stored_values
    create_preference(:owner => @user, :group_type => 'chat', :name => 'language', :value => 'English')
    assert_queries(1) { @user.preferred?(:language, :chat) }
    assert_queries(0) { @user.preferred?(:language, :chat) }
  end
  
  def test_should_be_able_to_use_prefers_reader
    assert_equal false, @user.prefers_language?(:chat)
  end
  
  def test_should_be_able_to_use_preferred_reader
    assert_equal false, @user.preferred_language?(:chat)
  end
end

class PreferencesARGroupQueryTest < ModelPreferenceTest
  def setup
    @car = create_car
    
    User.preference :language, :string
    @user = create_user
  end
  
  def test_should_be_true_if_present
    @user.preferred_language = 'English', @car
    assert_equal true, @user.preferred?(:language, @car)
  end
  
  def test_should_be_false_if_not_present
    assert_equal false, @user.preferred?(:language, @car)
  end
  
  def test_should_use_stored_value_if_stored
    create_preference(:owner => @user, :group_type => 'Car', :group_id => @car.id, :name => 'language', :value => 'English')
    assert_equal true, @user.preferred?(:language, @car)
  end
  
  def test_should_be_able_to_use_prefers_reader
    assert_equal false, @user.prefers_language?(@car)
  end
  
  def test_should_be_able_to_use_preferred_reader
    assert_equal false, @user.preferred_language?(@car)
  end
end

class PreferencesWriterTest < ModelPreferenceTest
  def setup
    User.preference :notifications, :boolean, :default => true
    User.preference :language, :string, :default => 'English'
    @user = create_user(:login => 'admin')
  end
  
  def test_should_raise_exception_if_invalid_preference_written
    exception = assert_raise(ArgumentError) { @user.write_preference(:invalid, true) }
    assert_equal 'Unknown preference: invalid', exception.message
  end
  
  def test_should_have_same_value_if_not_changed
    @user.write_preference(:notifications, true)
    assert_equal true, @user.preferred(:notifications)
  end
  
  def test_should_use_new_value_if_changed
    @user.write_preference(:notifications, false)
    assert_equal false, @user.preferred(:notifications)
  end
  
  def test_should_not_save_record_after_changing_preference
    @user.login = 'test'
    @user.write_preference(:notifications, false)
    
    assert_equal 'admin', User.find(@user.id).login
  end
  
  def test_should_not_create_stored_preferences_immediately
    @user.write_preference(:notifications, false)
    assert @user.stored_preferences.empty?
  end
  
  def test_should_not_create_stored_preference_if_value_not_changed
    @user.write_preference(:notifications, true)
    @user.save!
    
    assert_equal 0, @user.stored_preferences.count
  end
  
  def test_should_not_create_stored_integer_preference_if_typecast_not_changed
    User.preference :age, :integer
    
    @user.write_preference(:age, '')
    @user.save!
    
    assert_equal 0, @user.stored_preferences.count
  end
  
  def test_should_create_stored_integer_preference_if_typecast_changed
    User.preference :age, :integer, :default => 0
    
    @user.write_preference(:age, '')
    @user.save!
    
    assert_nil @user.preferred(:age)
    assert_equal 1, @user.stored_preferences.count
  end
  
  def test_should_create_stored_preference_if_value_changed
    @user.write_preference(:notifications, false)
    @user.save!
    
    assert_equal 1, @user.stored_preferences.count
  end
  
  def test_should_overwrite_existing_stored_preference_if_value_changed
    preference = create_preference(:owner => @user, :name => 'notifications', :value => true)
    
    @user.write_preference(:notifications, false)
    @user.save!
    
    preference.reload
    assert_equal false, preference.value
  end
  
  def test_should_not_remove_preference_if_set_to_default
    create_preference(:owner => @user, :name => 'notifications', :value => false)
    
    @user.write_preference(:notifications, true)
    @user.save!
    @user.reload
    
    assert_equal 1, @user.stored_preferences.size
    preference = @user.stored_preferences.first
    assert_equal true, preference.value
  end
  
  def test_should_not_remove_preference_if_set_to_nil
    create_preference(:owner => @user, :name => 'notifications', :value => false)
    
    @user.write_preference(:notifications, nil)
    @user.save!
    @user.reload
    
    assert_equal 1, @user.stored_preferences.size
    preference = @user.stored_preferences.first
    assert_nil preference.value
  end
  
  def test_should_not_query_for_old_value_if_preferences_loaded
    @user.preferences
    
    assert_queries(0) { @user.write_preference(:notifications, false) }
  end
end

class PreferencesGroupWriterTest < ModelPreferenceTest
  def setup
    User.preference :notifications, :boolean, :default => true
    User.preference :language, :string, :default => 'English'
    @user = create_user(:login => 'admin')
  end
  
  def test_should_have_same_value_if_not_changed
    @user.write_preference(:notifications, true, :chat)
    assert_equal true, @user.preferred(:notifications, :chat)
  end
  
  def test_should_use_new_value_if_changed
    @user.write_preference(:notifications, false, :chat)
    assert_equal false, @user.preferred(:notifications, :chat)
  end
  
  def test_should_not_create_stored_preference_if_value_not_changed
    @user.write_preference(:notifications, true, :chat)
    @user.save!
    
    assert_equal 0, @user.stored_preferences.count
  end
  
  def test_should_create_stored_preference_if_value_changed
    @user.write_preference(:notifications, false, :chat)
    @user.save!
    
    assert_equal 1, @user.stored_preferences.count
  end
  
  def test_should_set_group_attributes_on_stored_preferences
    @user.write_preference(:notifications, false, :chat)
    @user.save!
    
    preference = @user.stored_preferences.first
    assert_equal 'chat', preference.group_type
    assert_nil preference.group_id
  end
  
  def test_should_overwrite_existing_stored_preference_if_value_changed
    preference = create_preference(:owner => @user, :group_type => 'chat', :name => 'notifications', :value => true)
    
    @user.write_preference(:notifications, false, :chat)
    @user.save!
    
    preference.reload
    assert_equal false, preference.value
  end
end

class PreferencesARGroupWriterTest < ModelPreferenceTest
  def setup
    @car = create_car
    
    User.preference :notifications, :boolean, :default => true
    User.preference :language, :string, :default => 'English'
    @user = create_user(:login => 'admin')
  end
  
  def test_should_have_same_value_if_not_changed
    @user.write_preference(:notifications, true, @car)
    assert_equal true, @user.preferred(:notifications, @car)
  end
  
  def test_should_use_new_value_if_changed
    @user.write_preference(:notifications, false, @car)
    assert_equal false, @user.preferred(:notifications, @car)
  end
  
  def test_should_not_create_stored_preference_if_value_not_changed
    @user.write_preference(:notifications, true, @car)
    @user.save!
    
    assert_equal 0, @user.stored_preferences.count
  end
  
  def test_should_create_stored_preference_if_value_changed
    @user.write_preference(:notifications, false, @car)
    @user.save!
    
    assert_equal 1, @user.stored_preferences.count
  end
  
  def test_should_set_group_attributes_on_stored_preferences
    @user.write_preference(:notifications, false, @car)
    @user.save!
    
    preference = @user.stored_preferences.first
    assert_equal 'Car', preference.group_type
    assert_equal @car.id, preference.group_id
  end
end

class PreferencesAfterChangingPreferenceTest < ModelPreferenceTest
  def setup
    User.preference :notifications, :boolean, :default => true
    User.preference :language, :string, :default => 'English'
    @user = create_user
    
    @user.write_preference(:notifications, false)
  end
  
  def test_should_query_preferences_changed
    assert_equal true, @user.preferences_changed?
  end
  
  def test_should_query_preference_changed
    assert_equal true, @user.prefers_notifications_changed?
  end
  
  def test_should_not_query_preferences_changed_for_group
    assert_equal false, @user.preferences_changed?(:chat)
  end
  
  def test_should_not_query_preference_changed_for_group
    assert_equal false, @user.prefers_notifications_changed?(:chat)
  end
  
  def test_should_have_preferences_changed
    assert_equal ['notifications'], @user.preferences_changed
  end
  
  def test_should_not_build_same_preferences_changed_result
    assert_not_same @user.preferences_changed, @user.preferences_changed
  end
  
  def test_should_not_have_preferences_changed_for_group
    assert_equal [], @user.preferences_changed(:chat)
  end
  
  def test_should_track_multiple_preferences_changed
    @user.write_preference(:language, 'Latin')
    assert_equal ['language', 'notifications'], @user.preferences_changed.sort
  end
  
  def test_should_have_preference_changes
    assert_equal e = {'notifications' => [true, false]}, @user.preference_changes
  end
  
  def test_should_not_build_same_preference_changes_result
    assert_not_same @user.preference_changes, @user.preference_changes
  end
  
  def test_should_have_preference_change
    assert_equal [true, false], @user.prefers_notifications_change
  end
  
  def test_should_have_preference_was
    assert_equal true, @user.prefers_notifications_was
  end
  
  def test_should_not_have_preference_changes_for_group
    assert_equal e = {}, @user.preference_changes(:chat)
  end
  
  def test_should_not_have_preference_change_for_group
    assert_nil @user.prefers_notifications_change(:chat)
  end
  
  def test_should_have_preference_was_for_group
    assert_equal true, @user.prefers_notifications_was(:chat)
  end
  
  def test_should_use_latest_value_for_preference_changes
    @user.write_preference(:notifications, nil)
    assert_equal e = {'notifications' => [true, nil]}, @user.preference_changes
  end
  
  def test_should_use_cloned_old_value_for_preference_changes
    old_value = @user.preferred(:language)
    @user.write_preference(:language, 'Latin')
    
    tracked_old_value = @user.preference_changes['language'][0]
    assert_equal old_value, tracked_old_value
    assert_not_same old_value, tracked_old_value
  end
  
  def test_should_track_multiple_preference_changes
    @user.write_preference(:language, 'Latin')
    assert_equal e = {'notifications' => [true, false], 'language' => ['English', 'Latin']}, @user.preference_changes
  end
end

class PreferencesAfterChangingGroupPreferenceTest < ModelPreferenceTest
  def setup
    User.preference :notifications, :boolean, :default => true
    User.preference :language, :string, :default => 'English'
    @user = create_user
    
    @user.write_preference(:notifications, false, :chat)
  end
  
  def test_should_not_query_preferences_changed
    assert_equal false, @user.preferences_changed?
  end
  
  def test_not_should_query_preference_changed
    assert_equal false, @user.prefers_notifications_changed?
  end
  
  def test_should_query_preferences_changed_for_group
    assert_equal true, @user.preferences_changed?(:chat)
  end
  
  def test_should_query_preference_changed_for_group
    assert_equal true, @user.prefers_notifications_changed?(:chat)
  end
  
  def test_should_have_preferences_changed
    assert_equal [], @user.preferences_changed
  end
  
  def test_should_not_have_preferences_changed_for_group
    assert_equal ['notifications'], @user.preferences_changed(:chat)
  end
  
  def test_should_have_preference_changes
    assert_equal e = {}, @user.preference_changes
  end
  
  def test_should_not_have_preference_change
    assert_nil @user.prefers_notifications_change
  end
  
  def test_should_have_preference_was
    assert_equal true, @user.prefers_notifications_was
  end
  
  def test_should_not_have_preference_changes_for_group
    assert_equal e = {'notifications' => [true, false]}, @user.preference_changes(:chat)
  end
  
  def test_should_have_preference_change_for_group
    assert_equal [true, false], @user.prefers_notifications_change(:chat)
  end
  
  def test_should_have_preference_was_for_group
    assert_equal true, @user.prefers_notifications_was(:chat)
  end
end

class PreferencesAfterRevertPreferenceChangeTest < ModelPreferenceTest
  def setup
    User.preference :notifications, :boolean, :default => true
    
    @user = create_user
    @user.write_preference(:notifications, false)
    @user.write_preference(:notifications, true)
  end
  
  def test_should_not_query_preferences_changed
    assert_equal false, @user.preferences_changed?
  end
  
  def test_should_not_have_preferences_changed
    assert_equal [], @user.preferences_changed
  end
  
  def test_should_not_have_preference_changes
    assert_equal e = {}, @user.preference_changes
  end
end

class PreferencesAfterForcingChangeTest < ModelPreferenceTest
  def setup
    User.preference :notifications, :boolean, :default => true
    
    @user = create_user
    @user.prefers_notifications_will_change!
    @user.save
  end
  
  def test_should_store_preference
    assert_equal 1, @user.stored_preferences.count
    
    preference = @user.stored_preferences.first
    assert_equal nil, preference.group_type
    assert_equal nil, preference.group_id
    assert_equal true, preference.value
  end
end

class PreferencesAfterForcingChangeForGroupTest < ModelPreferenceTest
  def setup
    User.preference :notifications, :boolean, :default => true
    User.preference :language, :string, :default => 'English'
    
    @user = create_user
    @user.prefers_notifications_will_change!(:chat)
    @user.save
  end
  
  def test_should_store_preference
    assert_equal 1, @user.stored_preferences.count
    
    preference = @user.stored_preferences.first
    assert_equal 'chat', preference.group_type
    assert_equal nil, preference.group_id
    assert_equal true, preference.value
  end
  
  def test_should_use_cloned_value_for_tracking_old_value
    old_value = @user.preferred(:language)
    @user.preferred_language_will_change!
    
    tracked_old_value = @user.preferred_language_was
    assert_equal old_value, tracked_old_value
    assert_not_same old_value, tracked_old_value
  end
end

class PreferencesAfterResettingPreferenceTest < ModelPreferenceTest
  def setup
    User.preference :notifications, :boolean, :default => true
    
    @user = create_user
    @user.write_preference(:notifications, false)
    @user.write_preference(:notifications, false, :chat)
    @user.reset_prefers_notifications!
  end
  
  def test_should_revert_to_original_value
    assert_equal true, @user.preferred(:notifications)
  end
  
  def test_should_not_reset_groups
    assert_equal true, @user.preferred(:notifications, :chat)
  end
end

class PreferencesAfterResettingPreferenceTest < ModelPreferenceTest
  def setup
    User.preference :notifications, :boolean, :default => true
    
    @user = create_user
    @user.write_preference(:notifications, false)
    @user.write_preference(:notifications, false, :chat)
    @user.reset_prefers_notifications!(:chat)
  end
  
  def test_should_revert_to_original_value
    assert_equal true, @user.preferred(:notifications, :chat)
  end
  
  def test_should_not_reset_default_group
    assert_equal false, @user.preferred(:notifications)
  end
end

class PreferencesLookupTest < ModelPreferenceTest
  def setup
    User.preference :notifications, :boolean, :default => true
    User.preference :language, :string, :default => 'English', :group_defaults => {:chat => 'Latin'}
    
    @user = create_user
  end
  
  def test_should_only_have_defaults_if_nothing_customized
    assert_equal e = {'notifications' => true, 'language' => 'English'}, @user.preferences
  end
  
  def test_should_merge_defaults_with_unsaved_changes
    @user.write_preference(:notifications, false)
    assert_equal e = {'notifications' => false, 'language' => 'English'}, @user.preferences
  end
  
  def test_should_merge_defaults_with_saved_changes
    create_preference(:owner => @user, :name => 'notifications', :value => false)
    assert_equal e = {'notifications' => false, 'language' => 'English'}, @user.preferences
  end
  
  def test_should_merge_stored_preferences_with_unsaved_changes
    create_preference(:owner => @user, :name => 'notifications', :value => false)
    @user.write_preference(:language, 'Latin')
    assert_equal e = {'notifications' => false, 'language' => 'Latin'}, @user.preferences
  end
  
  def test_should_use_unsaved_changes_over_stored_preferences
    create_preference(:owner => @user, :name => 'notifications', :value => true)
    @user.write_preference(:notifications, false)
    assert_equal e = {'notifications' => false, 'language' => 'English'}, @user.preferences
  end
  
  def test_should_typecast_unsaved_changes
    @user.write_preference(:notifications, 'true')
    assert_equal e = {'notifications' => true, 'language' => 'English'}, @user.preferences
  end
  
  def test_should_cache_results
    assert_queries(1) { @user.preferences }
    assert_queries(0) { @user.preferences }
  end
  
  def test_should_not_query_if_stored_preferences_eager_loaded
    create_preference(:owner => @user, :name => 'notifications', :value => false)
    user = User.find(@user.id, :include => :stored_preferences)
    
    assert_queries(0) do
      assert_equal e = {'notifications' => false, 'language' => 'English'}, user.preferences
    end
  end
  
  def test_should_not_generate_same_object_twice
    assert_not_same @user.preferences, @user.preferences
  end
  
  def test_should_use_preferences_for_prefs
    assert_equal @user.preferences, @user.prefs
  end
end

class PreferencesGroupLookupTest < ModelPreferenceTest
  def setup
    User.preference :notifications, :boolean, :default => true
    User.preference :language, :string, :default => 'English', :group_defaults => {:chat => 'Latin'}
    
    @user = create_user
  end
  
  def test_should_only_have_defaults_if_nothing_customized
    assert_equal e = {'notifications' => true, 'language' => 'Latin'}, @user.preferences(:chat)
  end
  
  def test_should_merge_defaults_with_unsaved_changes
    @user.write_preference(:notifications, false, :chat)
    assert_equal e = {'notifications' => false, 'language' => 'Latin'}, @user.preferences(:chat)
  end
  
  def test_should_merge_defaults_with_saved_changes
    create_preference(:owner => @user, :group_type => 'chat', :name => 'notifications', :value => false)
    assert_equal e = {'notifications' => false, 'language' => 'Latin'}, @user.preferences(:chat)
  end
  
  def test_should_merge_stored_preferences_with_unsaved_changes
    create_preference(:owner => @user, :group_type => 'chat', :name => 'notifications', :value => false)
    @user.write_preference(:language, 'Spanish', :chat)
    assert_equal e = {'notifications' => false, 'language' => 'Spanish'}, @user.preferences(:chat)
  end
  
  def test_should_typecast_unsaved_changes
    @user.write_preference(:notifications, 'true', :chat)
    assert_equal e = {'notifications' => true, 'language' => 'English'}, @user.preferences
  end
  
  def test_should_cache_results
    assert_queries(1) { @user.preferences(:chat) }
    assert_queries(0) { @user.preferences(:chat) }
  end
  
  def test_should_not_query_if_all_preferences_individually_loaded
    @user.preferred(:notifications, :chat)
    @user.preferred(:language, :chat)
    
    assert_queries(0) { @user.preferences(:chat) }
  end
  
  def test_should_not_generate_same_object_twice
    assert_not_same @user.preferences(:chat), @user.preferences(:chat)
  end
end

class PreferencesARGroupLookupTest < ModelPreferenceTest
  def setup
    @car = create_car
    
    User.preference :notifications, :boolean, :default => true
    User.preference :language, :string, :default => 'English'
    
    @user = create_user
  end
  
  def test_should_only_have_defaults_if_nothing_customized
    assert_equal e = {'notifications' => true, 'language' => 'English'}, @user.preferences(@car)
  end
  
  def test_should_merge_defaults_with_unsaved_changes
    @user.write_preference(:notifications, false, @car)
    assert_equal e = {'notifications' => false, 'language' => 'English'}, @user.preferences(@car)
  end
  
  def test_should_merge_defaults_with_saved_changes
    create_preference(:owner => @user, :group_type => 'Car', :group_id => @car.id, :name => 'notifications', :value => false)
    assert_equal e = {'notifications' => false, 'language' => 'English'}, @user.preferences(@car)
  end
  
  def test_should_merge_stored_preferences_with_unsaved_changes
    create_preference(:owner => @user, :group_type => 'Car', :group_id => @car.id, :name => 'notifications', :value => false)
    @user.write_preference(:language, 'Latin', @car)
    assert_equal e = {'notifications' => false, 'language' => 'Latin'}, @user.preferences(@car)
  end
end

class PreferencesNilGroupLookupTest < ModelPreferenceTest
  def setup
    @car = create_car
    
    User.preference :notifications, :boolean, :default => true
    User.preference :language, :string, :default => 'English'
    
    @user = create_user
  end
  
  def test_should_only_have_defaults_if_nothing_customized
    assert_equal e = {'notifications' => true, 'language' => 'English'}, @user.preferences(nil)
  end
  
  def test_should_merge_defaults_with_unsaved_changes
    @user.write_preference(:notifications, false)
    assert_equal e = {'notifications' => false, 'language' => 'English'}, @user.preferences(nil)
  end
  
  def test_should_merge_defaults_with_saved_changes
    create_preference(:owner => @user, :name => 'notifications', :value => false)
    assert_equal e = {'notifications' => false, 'language' => 'English'}, @user.preferences(nil)
  end
  
  def test_should_merge_stored_preferences_with_unsaved_changes
    create_preference(:owner => @user, :name => 'notifications', :value => false)
    @user.write_preference(:language, 'Latin')
    assert_equal e = {'notifications' => false, 'language' => 'Latin'}, @user.preferences(nil)
  end
end

class PreferencesLookupWithGroupsTest < ModelPreferenceTest
  def setup
    User.preference :notifications, :boolean, :default => true
    User.preference :language, :string, :default => 'English'
    
    @user = create_user
    create_preference(:owner => @user, :group_type => 'chat', :name => 'notifications', :value => false)
  end
  
  def test_not_include_group_preferences_by_default
    assert_equal e = {'notifications' => true, 'language' => 'English'}, @user.preferences
  end
end

class PreferencesAfterBeingReloadedTest < ModelPreferenceTest
  def setup
    User.preference :notifications, :boolean, :default => true
    
    @user = create_user
    @user.write_preference(:notifications, false)
    @user.reload
  end
  
  def test_should_reset_unsaved_preferences
    assert_equal true, @user.preferred(:notifications)
  end
  
  def test_should_not_save_reset_preferences
    @user.save!
    assert @user.stored_preferences.empty?
  end
  
  def test_should_reset_preferences
    assert_equal e = {'notifications' => true}, @user.preferences
  end
  
  def test_should_clear_query_cache_for_preferences
    assert_queries(1) { @user.preferences }
  end
  
  def test_should_reset_preferences_changed_query
    assert_equal false, @user.preferences_changed?
  end
  
  def test_should_reset_preferences_changed
    assert_equal [], @user.preferences_changed
  end
  
  def test_should_reset_preference_changes
    assert_equal e = {}, @user.preference_changes
  end
end

class PreferencesForGroupAfterBeingReloadedTest < ModelPreferenceTest
  def setup
    User.preference :notifications, :boolean, :default => true
    
    @user = create_user
    @user.write_preference(:notifications, false, :chat)
    @user.reload
  end
  
  def test_should_reset_unsaved_preferences
    assert_equal true, @user.preferred(:notifications, :chat)
  end
  
  def test_should_reset_preferences
    assert_equal e = {'notifications' => true}, @user.preferences(:chat)
  end
  
  def test_should_clear_query_cache_for_preferences
    assert_queries(1) { @user.preferences(:chat) }
  end
  
  def test_should_reset_preferences_changed_query
    assert_equal false, @user.preferences_changed?(:chat)
  end
  
  def test_should_reset_preferences_changed
    assert_equal [], @user.preferences_changed(:chat)
  end
  
  def test_should_reset_preference_changes
    assert_equal e = {}, @user.preference_changes(:chat)
  end
end

class PreferencesWithScopeTest < ModelPreferenceTest
  def setup
    User.preference :notifications
    User.preference :language, :string, :default => 'English'
    User.preference :color, :string, :default => 'red'
    
    @user = create_user
    @customized_user = create_user(:login => 'customized',
      :prefers_notifications => false,
      :preferred_language => 'Latin'
    )
    @customized_user.prefers_notifications = false, :chat
    @customized_user.preferred_language = 'Latin', :chat
    @customized_user.save!
  end
  
  def test_should_not_find_if_no_preference_matched
    assert_equal [], User.with_preferences(:language => 'Italian')
  end
  
  def test_should_find_with_null_preference
    assert_equal [@user], User.with_preferences(:notifications => nil)
  end
  
  def test_should_find_with_default_preference
    assert_equal [@user], User.with_preferences(:language => 'English')
  end
  
  def test_should_find_with_multiple_default_preferences
    assert_equal [@user], User.with_preferences(:notifications => nil, :language => 'English')
  end
  
  def test_should_find_with_custom_preference
    assert_equal [@customized_user], User.with_preferences(:language => 'Latin')
  end
  
  def test_should_find_with_multiple_custom_preferences
    assert_equal [@customized_user], User.with_preferences(:notifications => false, :language => 'Latin')
  end
  
  def test_should_find_with_mixed_default_and_custom_preferences
    assert_equal [@customized_user], User.with_preferences(:color => 'red', :language => 'Latin')
  end
  
  def test_should_find_with_default_group_preference
    assert_equal [@user], User.with_preferences(:chat => {:language => 'English'})
  end
  
  def test_should_find_with_customized_default_group_preference
    User.preference :country, :string, :default => 'US', :group_defaults => {:chat => 'UK'}
    @customized_user.preferred_country = 'US', :chat
    @customized_user.save!
    
    assert_equal [@user], User.with_preferences(:chat => {:country => 'UK'})
  end
  
  def test_should_find_with_multiple_default_group_preferences
    assert_equal [@user], User.with_preferences(:chat => {:notifications => nil, :language => 'English'})
  end
  
  def test_should_find_with_custom_group_preference
    assert_equal [@customized_user], User.with_preferences(:chat => {:language => 'Latin'})
  end
  
  def test_should_find_with_multiple_custom_group_preferences
    assert_equal [@customized_user], User.with_preferences(:chat => {:notifications => false, :language => 'Latin'})
  end
  
  def test_should_find_with_mixed_default_and_custom_group_preferences
    assert_equal [@customized_user], User.with_preferences(:chat => {:color => 'red', :language => 'Latin'})
  end
  
  def test_should_find_with_mixed_basic_and_group_preferences
    @customized_user.preferred_language = 'English'
    @customized_user.save!
    
    assert_equal [@customized_user], User.with_preferences(:language => 'English', :chat => {:language => 'Latin'})
  end
  
  def test_should_allow_chaining
    assert_equal [@user], User.with_preferences(:language => 'English').with_preferences(:color => 'red')
  end
end

class PreferencesWithoutScopeTest < ModelPreferenceTest
  def setup
    User.preference :notifications
    User.preference :language, :string, :default => 'English'
    User.preference :color, :string, :default => 'red'
    
    @user = create_user
    @customized_user = create_user(:login => 'customized',
      :prefers_notifications => false,
      :preferred_language => 'Latin'
    )
    @customized_user.prefers_notifications = false, :chat
    @customized_user.preferred_language = 'Latin', :chat
    @customized_user.save!
  end
  
  def test_should_not_find_if_no_preference_matched
    assert_equal [], User.without_preferences(:color => 'red')
  end
  
  def test_should_find_with_null_preference
    assert_equal [@user], User.without_preferences(:notifications => false)
  end
  
  def test_should_find_with_default_preference
    assert_equal [@user], User.without_preferences(:language => 'Latin')
  end
  
  def test_should_find_with_multiple_default_preferences
    assert_equal [@user], User.without_preferences(:language => 'Latin', :notifications => false)
  end
  
  def test_should_find_with_custom_preference
    assert_equal [@customized_user], User.without_preferences(:language => 'English')
  end
  
  def test_should_find_with_multiple_custom_preferences
    assert_equal [@customized_user], User.without_preferences(:language => 'English', :notifications => nil)
  end
  
  def test_should_find_with_mixed_default_and_custom_preferences
    assert_equal [@customized_user], User.without_preferences(:language => 'English', :color => 'blue')
  end
  
  def test_should_find_with_default_group_preference
    assert_equal [@user], User.without_preferences(:chat => {:language => 'Latin'})
  end
  
  def test_should_find_with_customized_default_group_preference
    User.preference :country, :string, :default => 'US', :group_defaults => {:chat => 'UK'}
    @customized_user.preferred_country = 'US', :chat
    @customized_user.save!
    
    assert_equal [@user], User.without_preferences(:chat => {:country => 'US'})
  end
  
  def test_should_find_with_multiple_default_group_preferences
    assert_equal [@user], User.without_preferences(:chat => {:language => 'Latin', :notifications => false})
  end
  
  def test_should_find_with_custom_group_preference
    assert_equal [@customized_user], User.without_preferences(:chat => {:language => 'English'})
  end
  
  def test_should_find_with_multiple_custom_group_preferences
    assert_equal [@customized_user], User.without_preferences(:chat => {:language => 'English', :notifications => nil})
  end
  
  def test_should_find_with_mixed_default_and_custom_group_preferences
    assert_equal [@customized_user], User.without_preferences(:chat => {:language => 'English', :color => 'blue'})
  end
  
  def test_should_find_with_mixed_basic_and_group_preferences
    @customized_user.preferred_language = 'English'
    @customized_user.save!
    
    assert_equal [@customized_user], User.without_preferences(:language => 'Latin', :chat => {:language => 'English'})
  end
  
  def test_should_allow_chaining
    assert_equal [@user], User.without_preferences(:language => 'Latin').without_preferences(:color => 'blue')
  end
end
