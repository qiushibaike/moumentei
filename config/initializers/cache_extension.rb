# -*- encoding : utf-8 -*-
# CacheExtension
ActiveSupport::Cache::Store.class_eval do
  def get_multi(keys, options = nil)
    log("read multi", keys.join(', '), options)
    Hash[*keys.collect {|k| [k, read(k, options)]}.flatten]
  end
end

ActiveSupport::Cache::MemCacheStore.class_eval do
  def get_multi(keys, options=nil)
    log("read multi", keys.join(', '), options)
    @data.get_multi(*keys)
  rescue MemCache::MemCacheError => e
    logger.error("MemCacheError (#{e}): #{e.message}")
    nil
  end
end
