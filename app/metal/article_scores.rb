# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

# After generating static html pages, we ajax load current score information and
# current-user related informations. because the action is requested very
# freqently, i wrote a metal for this.
class ArticleScores
  def self.call(env)
    if env["PATH_INFO"] == '/scores'
      session = env["rack.session"]
      if session[:user_id]
        current_user = User.find_by_id(session[:user_id])
        logged_in = !!current_user
      end
      ids = env["QUERY_STRING"].gsub('ids=', '').split(/\+/).collect{|i|i.to_i}
      s = Article.find_all_by_id ids

      if logged_in
        rated= current_user.has_rated?(ids)
        watched = current_user.has_favorite?(ids)
      else
        rated = AnonymousRating.has_rated? env['REMOTE_ADDR'], ids
        cache_control = 'public'
      end
      m = {}
      s.each do |r|
        id = r.id
#        id = r['article_id']
        json = r.as_json(:only=> [:pos, :neg, :score])
        json['rated'] = rated[id]
        json['watched'] = !!watched[id] if logged_in
        m[id] = json
      end
      [200, {
          "Content-Type" => "application/json",
          "Cache-Control" => "private, max-age=5, s-maxage=15, must-revalidate, proxy-revalidate"
        }, [m.to_json]]
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end
end
