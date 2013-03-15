require File.dirname(__FILE__) + '/../test_helper'

class UserNotifierTest < ActionMailer::TestCase
  # Replace this with your real tests.
  fixtures :users
  def test_digest
    assert_emails 0
    UserNotifier.deliver_signup_notification(user(:pending))
    assert_emails 1
  end
end
