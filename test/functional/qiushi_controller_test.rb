require File.dirname(__FILE__) + '/../test_helper'
require 'qiushi_controller'

# Re-raise errors caught by the controller.
class QiushiController; def rescue_action(e) raise e end; end

class QiushiControllerTest < Test::Unit::TestCase
  def setup
    @controller = QiushiController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
