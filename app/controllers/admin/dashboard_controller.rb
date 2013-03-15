class Admin::DashboardController < Admin::BaseController
  reset_role_requirements!
  require_role ["doctor", "moderator"]
  def index
    
  end

end
