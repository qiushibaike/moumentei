# -*- encoding : utf-8 -*-
package :utils do
  requires :htop, :wget, :imagemagick
end

package :htop do
  apt 'htop'
end

package :wget do
  apt 'wget'
end

package :imagemagick do
  apt 'imagemagick'
  verify do
    has_executable 'convert'
    has_executable 'identify'
  end
end

package 'tokyocabinet' do
  apt 'libtokyocabinet'
end

package :python_software_properties do
  apt 'python-software-properties'
  verify do
    has_executable 'add-apt-repository'
  end
end
