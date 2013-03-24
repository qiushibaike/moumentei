namespace :moumentei do
  desc 'create package'
  task :obtain_jruby do
    jar_url = 'http://jruby.org.s3.amazonaws.com/downloads/1.7.3/jruby-complete-1.7.3.jar'
    path = Rails.root.join('vendor/jruby-complete.jar')
    unless File.exist?(path)
      File.open(path,"wb") do |f|
        f.write(open(jar_url).read)
      end
    end
  end
  task :package => [:obtain_jruby] do
    mkdir_p Rails.root.join('vendor/src')
    cp 'vendor'
  end
end