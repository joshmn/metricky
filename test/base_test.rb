require 'test_helper'

class Base::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Metricky
  end
end
