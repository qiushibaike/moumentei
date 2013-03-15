# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class SessionMetal
  def self.call(env)
    if env["PATH_INFO"] == "/session.js" and env['REQUEST_METHOD'] == 'GET'
      headers = {
        "Content-Type" => "application/json",
        "Cache-Control" => 'private, no-cache, no-store'
        }
      session = env["rack.session"]
      return [200, headers, [""]] unless session[:user_id]
      current_user = User.find_by_id session[:user_id]
      return [200, headers, [""]] unless current_user
      va = current_user.as_json(:only => [:id, :login, :state])
      va['unread_messages_count'] = current_user.unread_messages_count
      va['unread_notifications_count'] = current_user.notifications.unread.count
      #va['flash'] = flash unless flash.empty?

  #    va['notifications_count'] = current_user.notifications.count
  #    va['notifications'] = [current_user.notifications.first]
      #cookies['login'] = {:value => va.to_json}
      [200, headers, [va.to_json]]
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end
end
