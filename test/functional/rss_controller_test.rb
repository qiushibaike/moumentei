require File.dirname(__FILE__) + '/../test_helper'
require 'rss_controller'

# Re-raise errors caught by the controller.
class RssController; def rescue_action(e) raise e end; end

class RssControllerTest < Test::Unit::TestCase
  def setup
    @controller = RssController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
