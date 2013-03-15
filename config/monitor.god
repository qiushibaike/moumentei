RAILS_ROOT = File.dirname(File.dirname(File.expand_path(__FILE__)))
RUBY_ROOT="/opt/ree"
RUBY_BIN_DIR="#{RUBY_ROOT}/bin"
RUBY_BIN ="#{RUBY_BIN_DIR}/ruby"

God::Contacts::Email.message_settings = {
  :from => 'god@moumentei.com'
}
God.contact(:email) do |c|
  c.name = 'ShiningRay'
  c.email = 'tsowly@hotmail.com'
end

def generic_monitor(w, options={})
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 30.seconds
      c.running = false
    end
  end

  w.restart_if do |restart|
    if options[:memory_limit]
      restart.condition(:memory_usage) do |c|
        c.above = options[:memory_limit]
        c.times = [3, 5] # 3 out of 5 intervals
      end
    end
    if options[:cpu_usage]
      restart.condition(:cpu_usage) do |c|
        c.above = options[:cpu_limit]
        c.times = 5
      end
    end
  end

  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end
#

#nginx
God.watch do |nginx|
  nginx.name = 'nginx'
  nginx_bin              = '/opt/nginx/sbin/nginx'
  nginx.pid_file         = '/opt/nginx/logs/nginx.pid'
  nginx.start            = nginx_bin
  nginx.restart          = "kill -HUP `cat #{nginx.pid_file}`"
  nginx.stop             = "kill -QUIT `cat #{nginx.pid_file}`"
  nginx.start_grace   = 10.seconds
  nginx.restart_grace = 10.seconds
  generic_monitor(nginx)
end

God.watch do |haproxy|
  haproxy.name = 'haproxy'
  haproxy_bin = '/opt/nginx/sbin/haproxy'
  haproxy.pid_file = '/opt/nginx/logs/haproxy.pid'
  haproxy.start = "#{haproxy_bin} -f #{haproxy.pid_file}"
  generic_monitor(haproxy)
end

#apache
God.watch do |apache|
  apachectl = '/opt/apache2/bin/apachectl'
  apache.name = 'apache'
  apache.start = "#{apachectl} -k start"
  apache.stop = "#{apachectl} -k stop"
  apache.restart = "#{apachectl} -k restart"
  apache.pid_file = '/opt/apache2/logs/httpd.pid'
  apache.start_grace = 10.seconds
  apache.restart_grace = 10.seconds
  apache.behavior(:clean_pid_file)
  generic_monitor(apache)
end

#mysql
God.watch do |mysql|
  mysql.name = 'mysql'
  mysql_bin = '/opt/mysql/bin/mysqld_safe'
  mysql.pid_file = '/var/run/mysqld/mysqld.pid'
  mysql.start = '/etc/init.d/mysql.server start'
  mysql.stop = "/etc/init.d/mysql.server stop"
  #mysql.stop = "kill -QUIT `#{mysql.pid_file}`"
  mysql.start_grace = 1.minute
  mysql.restart_grace = 1.minute
  generic_monitor(mysql)
end

#memcached
#sudo /opt/memcached/bin/memcached -d -R 1024 -m 256 -t 10 -l 127.0.0.1 -P /home/www/qqq/tmp/pids/memcached.pid -u www-data
God.watch do |w|
  w.name = 'memcached'
  w.pid_file =  "#{RAILS_ROOT}/tmp/pids/memcached.pid"
  w.start = "/opt/memcached/bin/memcached -d -m 256 -t 2 -l 127.0.0.1 -P #{w.pid_file} -u www-data"
  w.stop = "kill -QUIT `#{w.pid_file}`"
  generic_monitor(w)
end


#php-cgi
God.watch do |w|
  w.name = 'php-cgi'
  php_bin = '/opt/php/bin/php-cgi'
  w.pid_file = '/tmp/php-cgi.pid'
  w.start = "/opt/lighttpd/bin/spawn-fcgi -f #{php_bin} -C 16 -s /tmp/php-fastcgi.sock -P #{w.pid_file} -u www-data -g www-data"
  w.stop = "kill -QUIT `cat #{w.pid_file}`"
  w.behavior(:clean_pid_file)
  generic_monitor(w)
end

#starling
#God.watch do |w|
#  starling = "#{RUBY_BIN_DIR}/starling"
#  w.name = 'starling'
#  w.pid_file = "/var/run/starling.pid"
#  w.start = "#{starling} start -d -P #{w.pid_file} -L #{RAILS_ROOT}/log/starling.log -u www-data -g www-data"
#  w.stop = "#{starling} stop -P #{w.pid_file}"
#  w.behavior(:clean_pid_file)
#  generic_monitor(w)
#end


(0...10).each do |i|
  port = 15000 + i
  God.watch do |thin|
    thin.group = 'thin'
    thin_bin = "#{RUBY_BIN_DIR}/thin"
    thin.name = "thin#{i}"
    thin.pid_file = "#{RAILS_ROOT}/tmp/pids/thin.#{i}.pid"
    thin.start = "#{thin_bin} start -e production -p #{i} -d"
    thin.stop = "#{thin_bin} stop -p #{i}"
    generic_monitor(thin)
  end
end
