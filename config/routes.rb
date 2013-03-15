ActionController::Routing::Routes.draw do |map|
  map.theme_support

  map.resources :pictures, :member => {:draw => :post}
  map.resources :oauth_clients
  map.report_comment 'comments/:id/report' ,:controller=>'comments',:action=>'report'
  map.test_request '/oauth/test_request', :controller => 'oauth', :action => 'test_request'
  map.access_token '/oauth/access_token', :controller => 'oauth', :action => 'access_token'
  map.request_token '/oauth/request_token', :controller => 'oauth', :action => 'request_token'
  map.authorize '/oauth/authorize', :controller => 'oauth', :action => 'authorize'
  map.oauth '/oauth', :controller => 'oauth', :action => 'index'
  map.home '', :controller => "groups", :action => "latest"
  #map.connect 'page/:page', :controller => "groups", :action => "latest"
  # map.connect '/chat', :controller => 'my', :action => 'chat'
  map.resources :quest_logs
  # map.resources :profiles
  map.resources :quests,
    :only => [:index, :show],
    :member => {
      :check => :any,
      :complete => :any
    }
  map.resources :lists, :has_many => :list_items, :member => {:append => :any, :sort=>:post}
  map.connect 'my/:id/get_balance', :controller => 'my', :action => 'get_salary'
  map.connect '/users/check_login', :controller => 'users', :action => 'check_login'
  map.connect '/users/check_email', :controller => 'users', :action => 'check_email'
  map.connect '/users/check_invitation_code', :controller => 'users', :action => 'check_invitation_code'
  map.connect '/users/search', :controller => 'users', :action => 'search'
  map.resources :posts, :member => {:reshare => :any, :reply => :post, :children => :get}
  map.resources :invitation_codes, :only => [:index, :new, :create]
  map.resources :badges, :only => [:index, :show]

  map.resources :messages, :only => [:new, :create, :destroy],
    :collection => {:inbox => :get, :outbox => :get}
  map.resources :notifications, :only => [:index, :show, :destroy], :collection => {:clear => :get , :clear_all => :get, :ignore => :post }

  map.resources :articles,
    :shallow => true,
      :member => {
      :move => :post,
      :draw => :any,
      :up => :any,
      :dn => :any,
      :report => :post,
      :score=>:get,
      :tickets_stats=> :get} do |article|
    article.resources :comments,
      :only => [:index, :create],
      :member => {:up => :any, :dn => :any},
      :collection => {:count => :get}
    article.connect 'comments/after/:after.:format', :controller => 'comments', :action => 'index'

    article.resources :tickets, :only => [:index, :new, :create], :collection => {:stats => :get}
    article.resources :metadatas
  end

  #map.article_comments 'articles/:article_id/comments/:page.:format', :controller => 'comments', :action => 'index'
  map.connect 'scores', :controller => 'articles', :action => 'scores'
  map.connect 'votes', :controller => 'articles', :action => 'votes'

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.connect '/fetchpass', :controller => 'users', :action => 'fetchpass'
  map.connect '/editpass', :controller => 'users', :action => 'editpass'
  map.active '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.resources :users, :member => {
    :followings => :get,
    :followers => :get,
    :follow => :post,
    :unfollow => :post,
    :report => :post,
    :comments => :get} do |user|
    user.resources :articles, :controller => "users/articles", :only => [:index]
    user.connect 'articles/page/:page.:format', :controller => 'users/articles', :action => :index
    user.resources :posts
    user.resources :groups, :controller => 'users/articles'
    user.resources :profiles
    #user.resources :comments
    #user.resources :lists
    #user.resources :lists, :only => [:index]
  end

  #map.user_comments '/users/:id/comments', :controller => 'users', :action  => 'comments'
  map.user_lists '/users/:id/lists',:controller => 'users',:action => 'lists'

  map.resource :session
  map.favorites "/favorites", :controller => 'favorites', :action => 'index'

  map.resources :groups do |group|
    group.resources :archives
    group.connect 'archives/:id/page/:page.:format', :controller => 'archives', :action => 'show'
    group.resources :articles
    group.resources :tags, :only => [:index, :show] do |tag|
      tag.resources :articles, :controller => 'tags/articles', :only => :index
      tag.connect 'articles/:order', :controller => 'tags/articles', :action => :index
      tag.connect 'articles/:order/page/:page.:format', :controller => 'tags/articles', :action => :index
    end
    group.latest 'latest.:format', :controller => 'groups', :action => 'latest'
    group.connect 'latest/page/:page.:format', :controller => :groups, :action => 'latest'
    
    group.connect 'hottest/:limit/page/:page.:format', :controller => 'groups', :action => 'hottest'
    group.hottest 'hottest/:limit.:format',
                  :controller => 'groups',
                  :action => 'hottest'
    group.picture 'pictures', :controller => 'groups', :action => 'pictures'
    group.connect 'pictures/:limit', :controller => 'groups', :action => 'pictures'
    group.connect 'pictures/:limit/page/:page.:format', :controller => 'groups', :action => 'pictures'
    group.most_replied 'most_replied/:limit/page/:page.:format', :controller => 'groups', :action => 'most_replied'
    group.resources :tickets, :only => [:index, :show, :create], :collection => {:submit => :get}
    group.connect '*path', :controller => 'pages', :action => 'show'
  end

=begin
  map.connect 'groups/:id/hottest/:limit.:format',
    :controller => 'groups',
    :action => 'hottest',
    :requirements => {:id => /\d+/}


  map.connect 'groups/:id/most_replied/:limit.:format',
    :controller => 'groups',
    :action => 'most_replied',
    :requirements => {:id => /\d+/}
=end
  map.connect 'favicon.ico', :controller => 'groups', :action => 'favicon'
  map.connect 'hottest/:limit/page/:page.:format', :controller => 'groups', :action => 'hottest'
  map.connect 'hottest/:limit.:format', :controller => 'groups', :action => 'hottest'
  map.hottest 'hottest.:format', :controller => 'groups', :action => 'hottest'
  map.latest  'latest/page/:page.:format', :controller => 'groups', :action => 'latest'
  map.connect 'latest.:format', :controller => 'groups', :action => 'latest'
  map.connect 'tags', :controller => 'groups', :action => 'tags'
  map.connect 'tag/:tag/page/:page', :controller => 'groups', :action => 'tag'
  map.connect 'tag/:tag', :controller => 'groups', :action => 'tag'
  map.connect 'rss.xml', :controller => 'groups', :action => 'rss'
  #  map.connect ':domain/archives/:year/:month/:day', :controller => 'groups', :action => 'archives', :requirements => { :domain => /[a-zA-Z0-9\-\.]+/ }
  #  map.connect ':domain/:action', :controller => 'groups', :requirements => { :domain => /[\w\-\.]+/ }
  map.namespace 'admin' do |admin|
    admin.connect 'statistic',:controller=>'statistic'
    admin.dashboard '/', :controller => 'dashboard'

    admin.resources :users, 
      :member => {:comments => :get, 
                  :suspend => :post, 
                  :unsuspend => :post,
                  :active => :post,
                  :delete_avatar => :post,
                  :delete_comments => :post,
                  :tickets=>:get},
      :has_many => :articles
    admin.resources :articles, #:has_many => [:comments],
      :member => {:move => :post, 
                  :track=>:post, 
                  :set_status => :post, 
                  :tickets=>:get, 
                  :clear_cache => :post},
      :collection => {:move => :post,:track=>:post, :batch_set_status => :post} do |article|
        article.comments 'comments', :controller => 'articles', :action => 'comments'
      end
    
    admin.resources :comments, :member => {:set_status => :post}, :collection => {:batch_set_status => :post}
    admin.resources :groups, :member => {:moveup=>:get, :movedown=>:get}
    admin.resources :themes
    admin.resources :ticket_types
    admin.resources :announcements
    admin.resources :badges
    admin.resources :tags
    admin.resources :invitation_codes, :collection => {:generate => :post}
    admin.resources :reports, :member => {:ignore => :post, :remove => :post},
      :collection => {:batch => :post}
    admin.resource :setting, :only => [:edit, :update]
    admin.resource :configuration, :only => [:edit, :update], :collection => {:restart => :any}
    admin.resources :pages
    admin.connect ':controller/:action'
  end


  #map.connect ':controller/:action/:id/page/:page', :requirements =>{ :page => /\d+/} #, :page => nil
  #map.connect ':controller/:action/page/:page', :requirements =>{ :page => /\d+/} #, :page => nil
  # Install the default route as the lowest priority.
  #map.connect ':controller/:action/:id.:format'
  #map.connect ':controller/:action/:id'
  
  map.connect 'my/:action/:id', :controller => 'my'
  map.connect 'my/:action',:controller => 'my'
  map.connect '*path', :controller => 'pages', :action => 'show'
  #  map.connect ':controller/service.wsdl', :action => 'wsdl'
end
