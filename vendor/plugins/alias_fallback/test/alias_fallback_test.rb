# -*- encoding : utf-8 -*-
require 'test_helper'

class AliasFallbackTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "alias fallback" do
    class A
      def hello(a=nil)
        a
      end
      def world
        hello('world')
      end
      alias_fallback :hello, :world
    end
    assert_equal('world', A.new.hello)
  end
end
