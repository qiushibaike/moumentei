# -*- encoding : utf-8 -*-
package :ruby_enterprise do
  description 'Ruby Enterprise Edition'
  version '1.8.7-2012.01'
  REE_PATH = "/usr/local" unless defined?(REE_PATH)

  binaries = %w(erb gem irb rake rdoc ree-version ri ruby testrb ruby_wrapper)
  # install ruby wrapper
  transfer 'vendor/ruby_wrapper', "#{REE_PATH}/bin/ruby_wrapper", :render => true, :sudo => true do
    post :install, "sudo chmod +x #{REE_PATH}/bin/ruby_wrapper"
  end
  
  source "http://rubyenterpriseedition.googlecode.com/files/ruby-enterprise-#{version}.tar.gz" do
    custom_install "sudo ./installer --auto=#{REE_PATH}"
#    binaries.each {|bin| 
#      target = "/usr/local/bin/#{bin}"
#      pre :install, "test -f #{target} && sudo rm -f #{target} || echo 1"
#      post :install, "test !-f #{target} && test -h #{target} && ln -nfs #{REE_PATH}/bin/#{bin} #{target} || echo 0"  
#    }
  end

  verify do
    has_directory install_path
    has_executable "#{REE_PATH}/bin/ruby"
    binaries.each do |bin| 
      has_file "#{REE_PATH}/bin/#{bin}"
      #has_symlink "/usr/local/bin/#{bin}", "#{REE_PATH}/bin/#{bin}" }
    end
  end

  requires :ree_dependencies
end

package :ree_dependencies do
  requires :zlib
  apt %w(libreadline-dev libssl-dev)
  requires :build_essential
end

package :bundler do 
  gem 'bundler'
  requires :ruby_enterprise
  verify do
    has_executable 'bundle'
  end
end
