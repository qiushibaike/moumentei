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

