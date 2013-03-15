# To change this template, choose Tools | Templates
# and open the template in the editor.

module Article::CacheMetaInfo
  module MemCacheStore
    def append_cached_key(key)
      cached_keys
      @need_append ||= !Rails.cache.write(key_for_cached_keys, key,
              :raw => true,
              :unless_exist => true )
      if @need_append and not cached_keys.include?(key)
        cached_keys << key
        Rails.cache.append(key_for_cached_keys, ",#{key}") 
      end
    end
  end

  module RedisStore

  end

  def self.included(base)
    base.send :include, MemCacheStore
  end

  def key_for_cached_keys
    "#{self.class.name}:#{self.id}:cached_keys"
  end

  def clear_related_caches
    cached_keys.each do |key|
      Rails.cache.delete key
    end
    clear_cached_keys
  end

  def remove_cached_key(key)
    c = cached_keys.unique
    k = c.delete(key)
    Rails.cache.write key_for_cached_keys, c.join(','), :raw => true
    k
  end

  def each_cached_key
    cache_keys.each do |key|
      yield key
    end
  end

  def cached_keys
    @cached_keys ||= begin
      c = Rails.cache.read(key_for_cached_keys, :raw => true)
      c.blank? ? [] : c.split(/,/)
    end
  end

  def clear_cached_keys
    Rails.cache.delete key_for_cached_keys
  end
end
