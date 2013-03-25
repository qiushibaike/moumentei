# -*- encoding : utf-8 -*-

package :passenger, :provides => :appserver do
  description 'Phusion Passenger (mod_rails)'
  version '3.0.11'
  binaries = %w(passenger-config passenger-install-nginx-module passenger-install-apache2-module passenger-make-enterprisey passenger-memory-stats passenger-status)
  
  gem 'passenger', :version => version do    
    # Install nginx and the module
    #binaries.each {|bin| post :install, "ln -s #{REE_PATH}/bin/#{bin} /usr/local/bin/#{bin}"}
    #post :install, "wget 
  end
  
  requires :ruby_enterprise
  
  verify do
    has_gem "passenger", version
    binaries.each do |bin|
      #has_symlink "/usr/local/bin/#{bin}", "#{REE_PATH}/bin/#{bin}"
      has_executable bin
    end
  end
end

package :passenger_nginx do
  requires :passenger
  requires :nginx
  requires :libcurl
  runner "sudo passenger-install-nginx-module --auto --prefix=/opt/nginx --nginx-source-dir=/tmp/nginx-1.0.12 --extra-configure-flags='--with-http_stub_status_module --with-http_gzip_static_module'" 
  runner "sudo /etc/init.d/nginx restart; true" 
  verify do
    has_executable_with_version '/opt/nginx/sbin/nginx', 'passenger', '-V'
  end
end
