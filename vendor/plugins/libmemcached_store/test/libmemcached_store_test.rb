require 'test/unit'
require 'rubygems'
require 'active_support'
require 'memcached'

require File.dirname(__FILE__) + '/../lib/active_support/cache/libmemcached_store'

# Make it easier to get at the underlying cache options during testing.
class ActiveSupport::Cache::LibmemcachedStore
  delegate :options, :to => '@cache'
end

class LibmemcachedStoreTest < Test::Unit::TestCase
  def setup
    @store = ActiveSupport::Cache.lookup_store :libmemcached_store
  end

  def test_should_identify_cache_store
    assert_kind_of ActiveSupport::Cache::LibmemcachedStore, @store
  end

  def test_should_set_server_addresses_to_localhost_if_none_are_given
    assert_equal %w(localhost), @store.addresses
  end

  def test_should_set_custom_server_addresses
    store = ActiveSupport::Cache.lookup_store :libmemcached_store, 'localhost', '192.168.1.1'
    assert_equal %w(localhost 192.168.1.1), store.addresses
  end

  def test_should_enable_consistent_hashing_by_default
    assert_equal :consistent, @store.options[:distribution]
  end

  def test_should_enable_non_blocking_io_by_default
    assert_equal true, @store.options[:no_block]
  end

  def test_should_enable_server_failover_by_default
    assert_equal true, @store.options[:failover]
  end

  def test_should_allow_configuration_of_custom_options
    options = {
      :prefix_key => 'test',
      :distribution => :modula,
      :no_block => false,
      :failover => false
    }

    store = ActiveSupport::Cache.lookup_store :libmemcached_store, 'localhost', options
    
    assert_equal 'test', store.options[:prefix_key]
    assert_equal :modula, store.options[:distribution]
    assert_equal false, store.options[:no_block]
    assert_equal false, store.options[:failover]
  end
end
