# -*- encoding : utf-8 -*-
class AuditLogger < Logger
  class << self
    def logger
      unless @file
        @file = File.open(Rails.root.join('log', 'admin.log'),'a')
        @file.sync = true
      end
      @logger ||= self.new(@file)
    end
    
    def log(user, *info)
      info.unshift user.login
      logger.info(info.join(' '))
      #logger.flush
    end
  end
  def format_message(severity, datetime, progname, msg)
      "[%s %s] %s\n" % [ severity, datetime.strftime("%Y-%m-%d %H:%M:%S"), msg ]
  end
end
