require File.dirname(__FILE__) + '/../test_helper'
require 'article_controller'

# Re-raise errors caught by the controller.
class ArticleController; def rescue_action(e) raise e end; end

class ArticleControllerTest < Test::Unit::TestCase
  def setup
    @controller = ArticleController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
