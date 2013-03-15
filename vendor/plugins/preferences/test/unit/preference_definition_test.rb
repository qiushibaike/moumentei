require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class PreferenceDefinitionByDefaultTest < ActiveSupport::TestCase
  def setup
    @definition = Preferences::PreferenceDefinition.new(:notifications)
  end
  
  def test_should_have_a_name
    assert_equal 'notifications', @definition.name
  end
  
  def test_should_not_have_a_default_value
    assert_nil @definition.default_value
  end
  
  def test_should_have_a_type
    assert_equal :boolean, @definition.type
  end
  
  def test_should_type_cast_values_as_booleans
    assert_equal nil, @definition.type_cast(nil)
    assert_equal true, @definition.type_cast(true)
    assert_equal false, @definition.type_cast(false)
    assert_equal false, @definition.type_cast(0)
    assert_equal true, @definition.type_cast(1)
  end
end

class PreferenceDefinitionTest < ActiveSupport::TestCase
  def test_should_raise_exception_if_invalid_option_specified
    assert_raise(ArgumentError) {Preferences::PreferenceDefinition.new(:notifications, :invalid => true)}
  end
end

class PreferenceDefinitionWithDefaultValueTest < ActiveSupport::TestCase
  def setup
    @definition = Preferences::PreferenceDefinition.new(:notifications, :boolean, :default => 1)
  end
  
  def test_should_type_cast_default_values
    assert_equal true, @definition.default_value
  end
end

class PreferenceDefinitionWithGroupDefaultsTest < ActiveSupport::TestCase
  def setup
    @definition = Preferences::PreferenceDefinition.new(:notifications, :boolean, :default => 1, :group_defaults => {:chat => 0})
  end
  
  def test_should_use_default_for_default_group
    assert_equal true, @definition.default_value
  end
  
  def test_should_use_default_for_unknown_group
    assert_equal true, @definition.default_value('email')
  end
  
  def test_should_use_group_default_for_known_group
    assert_equal false, @definition.default_value('chat')
  end
end

class PreferenceDefinitionWithStringifiedTypeTest < ActiveSupport::TestCase
  def setup
    @definition = Preferences::PreferenceDefinition.new(:notifications, 'any')
  end
  
  def test_should_symbolize_type
    assert_equal :any, @definition.type
  end
end

class PreferenceDefinitionWithAnyTypeTest < ActiveSupport::TestCase
  def setup
    @definition = Preferences::PreferenceDefinition.new(:notifications, :any)
  end
  
  def test_use_custom_type
    assert_equal :any, @definition.type
  end
  
  def test_should_not_be_number
    assert !@definition.number?
  end
  
  def test_should_not_type_cast
    assert_equal nil, @definition.type_cast(nil)
    assert_equal 0, @definition.type_cast(0)
    assert_equal 1, @definition.type_cast(1)
    assert_equal false, @definition.type_cast(false)
    assert_equal true, @definition.type_cast(true)
    assert_equal '', @definition.type_cast('')
  end
  
  def test_should_query_false_if_value_is_nil
    assert_equal false, @definition.query(nil)
  end
  
  def test_should_query_true_if_value_is_zero
    assert_equal true, @definition.query(0)
  end
  
  def test_should_query_true_if_value_is_not_zero
    assert_equal true, @definition.query(1)
    assert_equal true, @definition.query(-1)
  end
  
  def test_should_query_false_if_value_is_blank
    assert_equal false, @definition.query('')
  end
  
  def test_should_query_true_if_value_is_not_blank
    assert_equal true, @definition.query('hello')
  end
end

class PreferenceDefinitionWithBooleanTypeTest < ActiveSupport::TestCase
  def setup
    @definition = Preferences::PreferenceDefinition.new(:notifications)
  end
  
  def test_should_not_be_number
    assert !@definition.number?
  end
  
  def test_should_not_type_cast_if_value_is_nil
    assert_equal nil, @definition.type_cast(nil)
  end
  
  def test_should_type_cast_to_false_if_value_is_zero
    assert_equal false, @definition.type_cast(0)
  end
  
  def test_should_type_cast_to_true_if_value_is_not_zero
    assert_equal true, @definition.type_cast(1)
  end
  
  def test_should_type_cast_to_true_if_value_is_true_string
    assert_equal true, @definition.type_cast('true')
  end
  
  def test_should_type_cast_to_nil_if_value_is_not_true_string
    assert_nil @definition.type_cast('')
  end
  
  def test_should_query_false_if_value_is_nil
    assert_equal false, @definition.query(nil)
  end
  
  def test_should_query_true_if_value_is_one
    assert_equal true, @definition.query(1)
  end
  
  def test_should_query_false_if_value_not_one
    assert_equal false, @definition.query(0)
  end
  
  def test_should_query_true_if_value_is_true_string
    assert_equal true, @definition.query('true')
  end
  
  def test_should_query_false_if_value_is_not_true_string
    assert_equal false, @definition.query('')
  end
end

class PreferenceDefinitionWithNumericTypeTest < ActiveSupport::TestCase
  def setup
    @definition = Preferences::PreferenceDefinition.new(:notifications, :integer)
  end
  
  def test_should_be_number
    assert @definition.number?
  end
  
  def test_should_type_cast_true_to_integer
    assert_equal 1, @definition.type_cast(true)
  end
  
  def test_should_type_cast_false_to_integer
    assert_equal 0, @definition.type_cast(false)
  end
  
  def test_should_type_cast_string_to_integer
    assert_equal 0, @definition.type_cast('hello')
  end
  
  def test_should_query_false_if_value_is_nil
    assert_equal false, @definition.query(nil)
  end
  
  def test_should_query_true_if_value_is_one
    assert_equal true, @definition.query(1)
  end
  
  def test_should_query_false_if_value_is_zero
    assert_equal false, @definition.query(0)
  end
end

class PreferenceDefinitionWithStringTypeTest < ActiveSupport::TestCase
  def setup
    @definition = Preferences::PreferenceDefinition.new(:notifications, :string)
  end
  
  def test_should_not_be_number
    assert !@definition.number?
  end
  
  def test_should_type_cast_integers_to_strings
    assert_equal '1', @definition.type_cast('1')
  end
  
  def test_should_not_type_cast_booleans
    assert_equal true, @definition.type_cast(true)
  end
  
  def test_should_query_false_if_value_is_nil
    assert_equal false, @definition.query(nil)
  end
  
  def test_should_query_true_if_value_is_one
    assert_equal true, @definition.query(1)
  end
  
  def test_should_query_true_if_value_is_zero
    assert_equal true, @definition.query(0)
  end
  
  def test_should_query_false_if_value_is_blank
    assert_equal false, @definition.query('')
  end
  
  def test_should_query_true_if_value_is_not_blank
    assert_equal true, @definition.query('hello')
  end
end
