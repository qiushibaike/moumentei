begin
  require_library_or_gem 'memcached'

  module ActionController
    module Session
      class LibmemcachedStore < AbstractStore
        def initialize(app, options = {})

          super
          options[:expire_after] ||= options[:expires]
          @default_options = {
            :prefix_key => 'rack:session',
            :memcache_server => 'localhost:11211'
          }.merge(@default_options)

          @pool = options[:cache] || Memcached.new(@default_options[:memcache_server], @default_options)
          @mutex = Mutex.new

          super
        end

        private
        def get_session(env, sid)
          sid ||= generate_sid
          begin
            session = @pool.get(sid) || {}
          rescue Memcached::NotFound
            session = {}
          rescue Memcached::Error => e
            log_error(e)
            session = {}
          end
          [sid, session]
        end

        def set_session(env, sid, session_data)
          options = env['rack.session.options']
          expiry  = options[:expire_after] || 0
          @pool.set(sid, session_data, expiry)
          return true
        rescue Memcached::Error => e
          log_error(e)
          return false
        end
		  
        def log_error(exception)
          logger ||= RAILS_DEFAULT_LOGGER
          logger.error "MemcachedError (#{exception.inspect}): #{exception.message}" if logger && !@logger_off
        end
      end
    end
  end
rescue LoadError
  # MemCache wasn't available so neither can the store be
end
