# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Setting do
  it "should store key-value" do
    Setting[:test_key] = '123'
    Setting[:test_key].should == '123'
    Setting.test_key.should == '123'
    Setting.test_key2 = '123'
    Setting.test_key2.should == '123'
    Setting.test_key3 = {:a => 1, :b => 2}
    Setting.test_key3.should == {:a => 1, :b => 2}
  end
end
