# -*- encoding : utf-8 -*-
#-*- coding:utf-8 -*-
#unless [].respond_to?(:nitems)
#  class Array
#    def nitems
#      reject(&:nil?).size
#    end
#  end
#end
#unless ''.respond_to?(:inject)
#  class String
#    def inject(r)
#      each_char {|i| r = yield r, i}
#      r
#    end
#  end
#end
#unless {}.respond_to?(:inject)
#  class Hash
#    def inject(r)
#      each_pair do |k, v|
#        r = yield r, [k, v]
#      end
#      r
#    end
#  end
#end

def ip2long(ip)
  a = 0
  b = 24
  ip.split('.').each do |c|
    a += (c.to_i << b)
    b -= 8
  end
  a
end
def long2ip(ip)
  a = []
  while ip > 0
    a << (ip & 0xFF)
    ip >>= 8
  end
  a.reverse.join('.')
end
#if false#RUBY_VERSION >= '1.9'
#    require 'iconv'
#
#    ::ERB.class_eval do
#      alias_method :orig_init, :initialize
#      def initialize(a, *b)
#        orig_init(Iconv.conv('utf-8', 'US-ASCII', a), *b)
#      end
#    end
#end
class String
  def rot13
    tr "A-Za-z", "N-ZA-Mn-za-m";
  end
  def rot13!
    tr! "A-Za-z", "N-ZA-Mn-za-m";
  end
end
unless defined?(ap)
  def ap *args
    
  end
end
