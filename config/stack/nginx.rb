# -*- encoding : utf-8 -*-
# =========
# = Notes =
# =========

# The phusion guys have made it so that you can install nginx and passenger in one 
# fell swoop, it is for this reason and cleanliness that I haven't decided to install
# nginx and passenger separately, otherwise nginx ends up being dependent on passenger
# so that it can call --add-module within its configure statement - That in itself would
# be strange. 
NGINX_PATH='/opt/nginx'
package :nginx, :provides => :webserver do
  puts "** Nginx installed by passenger gem **"
  version '1.0.12'
  requires :libpcre
  requires :zlib
  NGINX_PATH='/opt/nginx'
  #file = File.join(File.dirname(__FILE__), 'nginx', 'init.d')
  source "http://nginx.org/download/nginx-#{version}.tar.gz" do
    prefix NGINX_PATH
    builds '/tmp'
  end

  verify do
    has_executable "#{NGINX_PATH}/sbin/nginx"
  end
end

package :nginx_init do 
  requires :nginx
  trasnfer 'config/stack/nginx/init.d', "/etc/init.d/nginx", :render => true, :sudo => true do
    post :install, "sudo chmod +x /etc/init.d/nginx"
    post :install, "sudo /usr/sbin/update-rc.d -f nginx defaults"
    post :install, "sudo /etc/init.d/nginx start"
  end  
  verify do
    has_executable "/etc/init.d/nginx"
  end
end
