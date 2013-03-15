require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class PreferenceByDefaultTest < ActiveSupport::TestCase
  def setup
    @preference = Preference.new
  end
  
  def test_should_not_have_a_name
    assert @preference.name.blank?
  end
  
  def test_should_not_have_an_owner
    assert_nil @preference.owner_id
  end
  
  def test_should_not_have_an_owner_type
    assert @preference.owner_type.blank?
  end
  
  def test_should_not_have_a_group_association
    assert_nil @preference.group_id
  end
  
  def test_should_not_have_a_group_type
    assert @preference.group_type.nil?
  end
  
  def test_should_not_have_a_value
    assert @preference.value.blank?
  end
  
  def test_should_not_have_a_definition
    assert_nil @preference.definition
  end
end

class PreferenceTest < ActiveSupport::TestCase
  def test_should_be_valid_with_a_set_of_valid_attributes
    preference = new_preference
    assert preference.valid?
  end
  
  def test_should_require_a_name
    preference = new_preference(:name => nil)
    assert !preference.valid?
    assert preference.errors.invalid?(:name)
  end
  
  def test_should_require_an_owner_id
    preference = new_preference(:owner => nil)
    assert !preference.valid?
    assert preference.errors.invalid?(:owner_id)
  end
  
  def test_should_require_an_owner_type
    preference = new_preference(:owner => nil)
    assert !preference.valid?
    assert preference.errors.invalid?(:owner_type)
  end
  
  def test_should_not_require_a_group_id
    preference = new_preference(:group => nil)
    assert preference.valid?
  end
  
  def test_should_not_require_a_group_id_if_type_specified
    preference = new_preference(:group => nil)
    preference.group_type = 'Car'
    assert preference.valid?
  end
  
  def test_should_not_require_a_group_type
    preference = new_preference(:group => nil)
    assert preference.valid?
  end
  
  def test_should_require_a_group_type_if_id_specified
    preference = new_preference(:group => nil)
    preference.group_id = 1
    assert !preference.valid?
    assert preference.errors.invalid?(:group_type)
  end
  
  def test_should_protect_attributes_from_mass_assignment
    preference = Preference.new(
      :id => 1,
      :name => 'notifications',
      :value => '123',
      :owner_id => 1,
      :owner_type => 'User',
      :group_id => 1,
      :group_type => 'Car'
    )
    
    assert_nil preference.id
    assert_equal 'notifications', preference.name
    assert_equal '123', preference.value
    assert_equal 1, preference.owner_id
    assert_equal 'User', preference.owner_type
    assert_equal 1, preference.group_id
    assert_equal 'Car', preference.group_type
  end
end

class PreferenceAsAClassTest < ActiveSupport::TestCase
  def test_should_be_able_to_split_nil_groups
    group_id, group_type = Preference.split_group(nil)
    assert_nil group_id
    assert_nil group_type
  end
  
  def test_should_be_able_to_split_non_active_record_groups
    group_id, group_type = Preference.split_group('car')
    assert_nil group_id
    assert_equal 'car', group_type
    
    group_id, group_type = Preference.split_group(:car)
    assert_nil group_id
    assert_equal 'car', group_type
    
    group_id, group_type = Preference.split_group(10)
    assert_nil group_id
    assert_equal 10, group_type
  end
  
  def test_should_be_able_to_split_active_record_groups
    car = create_car
    
    group_id, group_type = Preference.split_group(car)
    assert_equal 1, group_id
    assert_equal 'Car', group_type
  end
end

class PreferenceAfterBeingCreatedTest < ActiveSupport::TestCase
  def setup
    User.preference :notifications, :boolean
    
    @preference = create_preference(:name => 'notifications')
  end
  
  def test_should_have_an_owner
    assert_not_nil @preference.owner
  end
  
  def test_should_have_a_definition
    assert_not_nil @preference.definition
  end
  
  def test_should_have_a_value
    assert_not_nil @preference.value
  end
  
  def test_should_not_have_a_group_association
    assert_nil @preference.group
  end
  
  def teardown
    User.preference_definitions.delete('notifications')
  end
end

class PreferenceWithBasicGroupTest < ActiveSupport::TestCase
  def setup
    @preference = create_preference(:group_type => 'car')
  end
  
  def test_should_have_a_group_association
    assert_equal 'car', @preference.group
  end
end

class PreferenceWithActiveRecordGroupTest < ActiveSupport::TestCase
  def setup
    @car = create_car
    @preference = create_preference(:group => @car)
  end
  
  def test_should_have_a_group_association
    assert_equal @car, @preference.group
  end
end

class PreferenceWithBooleanTypeTest < ActiveSupport::TestCase
  def setup
    User.preference :notifications, :boolean
  end
  
  def test_should_type_cast_nil_values
    preference = new_preference(:name => 'notifications', :value => nil)
    assert_nil preference.value
  end
  
  def test_should_type_cast_numeric_values
    preference = new_preference(:name => 'notifications', :value => 0)
    assert_equal false, preference.value
    
    preference.value = 1
    assert_equal true, preference.value
  end
  
  def test_should_type_cast_boolean_values
    preference = new_preference(:name => 'notifications', :value => false)
    assert_equal false, preference.value
    
    preference.value = true
    assert_equal true, preference.value
  end
  
  def teardown
    User.preference_definitions.delete('notifications')
  end
end

class PreferenceWithSTIOwnerTest < ActiveSupport::TestCase
  def setup
    @manager = create_manager
    @preference = create_preference(:owner => @manager, :name => 'health_insurance', :value => true)
  end
  
  def test_should_have_an_owner
    assert_equal @manager, @preference.owner
  end
  
  def test_should_have_an_owner_type
    assert_equal 'Employee', @preference.owner_type
  end
  
  def test_should_have_a_definition
    assert_not_nil @preference.definition
  end
  
  def test_should_have_a_value
    assert_equal true, @preference.value
  end
end
