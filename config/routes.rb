# -*- encoding : utf-8 -*-
Moumentei::Application.routes.draw do
  themes_for_rails

   root :to => "groups#index"

   match '/oauth/test_request'  => "oauth#test_request",  :as  => :test_request
   match '/oauth/access_token'  => "oauth#access_token",  :as  => :access_token
   match '/oauth/request_token' => "oauth#request_token", :as  => :request_token
   match '/oauth/authorize'     => "oauth#authorize",     :as  => :authorize
   match '/oauth'               => "oauth#index",         :as  => :oauth

   match 'scores' => "articles#scores"
   match 'votes'  => "articles#votes"

   match '/logout'   => "sessions#destroy", :as  => :logout
   match '/login'    => "sessions#new",     :as  => :login
   match '/register' => "users#create",     :as  => :register
   match '/signup'   => "users#new",        :as  => :signup
   match '/activate/:activation_code' => 'users#activate',:as => :activate

   match '/fetchpass' => "users#fetchpass"
   match '/editpass'  => "users#editpass"

   resources :oauth_clients
   resource :session

   #match 'page/:page'=> "groups#latest"
   # match '/chat'=> "my#chat"
   resources :lists do
      resources :list_items
      member do
         get :append
         post :sort
      end
   end
   match 'my/:id/get_balance'           => "my#get_salary"
   match '/users/check_login'           => "users#check_login"
   match '/users/check_email'           => "users#check_email"
   match '/users/check_invitation_code' => "users#check_invitation_code"
   match '/users/search'                => "users#search"
   resources :posts do
      member do
         post :reshare
         post :reply
         get :children
      end
   end
   resources :invitation_codes, :only => [:index, :new, :create]
   resources :badges, :only => [:index, :show]

   resources :messages, :only => [:new, :create, :destroy] do
      collection do
         get :inbox
         get :outbox
      end
   end
   resources :notifications, :only => [:index, :show, :destroy] do
      collection do
         get :clear
         get :clear_all
         post :ignore
      end
   end

   resources :articles, :shallow => true do
      member do
         post :move
         post :draw
         post :up
         post :dn
         post :report
         get :score
         get :tickets_stats
      end
      resources :comments, :only => [:index, :create] do
         member do
            post :up
            post :dn
         end

         collection do
            get :count
         end
      end
      match 'comments/after/:after(.:format)'=> "comments#index"

      resources :tickets, :only => [:index, :new, :create] do
         collection do
            get :stats
         end
      end
      resources :metadatas
   end

   resources :users do
      member do
         get :followings
         get :followers
         post :follow
         post :unfollow
         post :report
         get :comments
      end
      resources :articles, :only => [:index]
      match 'articles(/page/:page)(.:format)', :action => :index
      resources :posts
      resources :groups
      resources :profiles
   end

   #user_comments '/users/:id/comments'=> "users#comments"
   match '/users/:id/lists'=> "users#lists", :as => :user_lists


   match "/favorites"=> "favorites#index", :as => :favorites
   resources :archives
   resources :groups do
      resources :archives
      match 'archives/:id(/page/:page)(.:format)'=> "archives#show"
      resources :articles
      resources :tags, :only => [:index, :show] do
         resources :articles, :only => :index
         match 'articles/:order(/page/:page)(.:format)' => 'tags/articles#index'
      end
      match 'latest(/page/:page)(.:format)'                => 'groups#latest',       :as  => :latest
      match 'recent_hot(/page/:page)(.:format)'            => "groups#recent_hot",   :as  => :recent_hot
      match 'hottest(/:limit(/page/:page))(.:format)'      => "groups#hottest",      :as  => :hottest
      match 'pictures(/:limit(/page/:page))(.:format)'     => "groups#pictures",     :as  => :picture
      match 'most_replied(/:limit(/page/:page))(.:format)' => "groups#most_replied", :as  => :most_replied
      resources :tickets, :only => [:index, :show, :create] do
         collection do
            get :submit
         end
      end
      match 'pages/*path'=> "pages#show"
   end

   match 'favicon.ico'=> "groups#favicon"
   match 'hottest(/:limit(/page/:page))(.:format)'=> "groups#hottest", :as => :hottest
   match 'latest(/page/:page)(.:format)'=> "groups#latest", :as => :latest
   match 'tags'=> "groups#tags"
   match 'tag/:tag(/page/:page)'=> "groups#tag"
   match 'rss.xml'=> "groups#rss"
   #  match ':domain/archives/:year/:month/:day'=> "groups#archives", :requirements => { :domain => /[a-zA-Z0-9\-\.]+/ }
   #  match ':domain/:action', :controller => 'groups', :requirements => { :domain => /[\w\-\.]+/ }
   namespace 'admin' do
      match 'statistic/:action' => 'statistic'
      match '/' => 'dashboard#index', :as => :dashboard

      resources :users do
         member do
            get :comments
            post :suspend
            post :unsuspend
            get :activate
            post :delete_avatar
            post :delete_comments
            get :tickets
         end
         resources :articles
      end
      resources :articles do
         member do
            post :move
            post :track
            post :set_status
            get :tickets
            post :clear_cache
         end
         collection do
            post :move
            post :track
            post :batch_set_status
         end
         resources :comments do
            member do
               post :set_status
            end
            collection do
               post :batch_set_status
            end
         end
      end
      resources :groups do
         member do
            get :moveup
            get :movedown
         end
      end
      resources :themes
      resources :ticket_types
      resources :announcements
      resources :badges
      resources :tags
      resources :invitation_codes do
         collection do
            post :generate
         end
      end
      #resources :reports, member do
      #:ignore => :post, :remove => :post
      #end,
      #  collection do
      #:batch => :post
      #end
      resource :setting, :only => [:edit, :update]
      #resource :configuration, :only => [:edit, :update], collection do
      #:restart => :post
      #end
      resources :pages
      #match ':controller/:action'
   end


   #match ':controller/:action/:id/page/:page', :requirements =>{ :page => /\d+/} #, :page => nil
   #match ':controller/:action/page/:page', :requirements =>{ :page => /\d+/} #, :page => nil
   # Install the default route as the lowest priority.
   #match ':controller/:action/:id(.:format)'
   #match ':controller/:action/:id'
   match 'pages/*path' => "pages#show"
   match 'my/:action/:id' => 'my'
   match 'my/:action' => 'my'
   #  match ':controller/service.wsdl', :action => 'wsdl'
end
