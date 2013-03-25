# -*- encoding : utf-8 -*-
# wget http://www.coreseek.cn/uploads/csft/3.1/Source/mmseg-3.1.tar.gz
# wget http://www.coreseek.cn/uploads/csft/3.1/Source/csft-3.1.tar.gz
# tar zxvf mmseg-3.1.tar.gz 
# cd mmseg-3.1/
# ./configure --prefix=/opt/mmseg
# make
# sudo make install
# cd ..
# tar zxvf csft-3.1.tar.gz 
# cd csft-3.1/
# ./configure --with-mmseg-includes=/opt/mmseg/include/mmseg --with-mmseg-libs=/opt/mmseg/lib --enable-id64 --prefix=/opt/csft
# make
# sudo make install
# cd ..
# cd mmseg-3.1/data
# /opt/mmseg/bin/mmseg -u unigram.txt 
# sudo cp unigram.txt.uni /opt/csft/var/data/uni.lib
# cd ..
# sudo cp src/win32/mmseg.ini /opt/csft/var/data/

package :libmmseg do
  source 'http://www.coreseek.cn/uploads/csft/3.1/Source/mmseg-3.1.tar.gz' do
    prefix '/opt/mmseg'
    builds '/tmp/builds'
    post :install do
      runner "cd #{build_dir}/data && /opt/mmseg/bin/mmseg -u unigram.txt && cp unigram.txt.uni /opt/mmseg/uni.lib && cd .. && cp src/win32/mmseg.ini /opt/mmseg"
    end  
  end
  requires :build_essential
  verify { has_executable '/opt/mmseg/bin/mmseg' }
end

package :csft do
  requires :libmmseg
  source 'http://www.coreseek.cn/uploads/csft/3.1/Source/csft-3.1.tar.gz' do
      prefix '/opt/csft'
      post :install do
        runner "cp /opt/mmseg/uni.lib /opt/csft/var/data/ && cp /opt/mmseg/mmseg.ini /opt/csft/var/data/"
      end
      with 'mmseg-includes=/opt/mmseg/include/mmseg'
      with 'mmseg-libs=/opt/mmseg/lib'
      enable 'id64'
    end
  verify do
    %w(indexer search searchd spelldump).each {|exe| has_executable "/opt/csft/bin/#{exe}" }
    #has_executable '/opt/csft/bin/'
  end
end

package :sphinx do
  requires :libmmseg
  requires :csft
end
