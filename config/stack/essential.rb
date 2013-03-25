# -*- encoding : utf-8 -*-
package :build_essential do
  description 'Build tools'
  apt 'build-essential' do
    pre :install, 'apt-get update'
  end
end

package :libpcre do
  apt 'libpcre3-dev'
end

package :zlib do
  apt 'zlib1g-dev'
end

package :libcurl do
  apt 'libcurl4-openssl-dev'
end
