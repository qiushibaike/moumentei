# -*- encoding : utf-8 -*-
# cache meta data in object
module Article::MetadataLocalCache
  def get_metadata(key)
    local_meta_cache[key] ||= super
  end

  def set_metdata(key, value)
    local_meta_cache[key] = super
  end

  def get_metadatas(*keys)
    keys.flatten!
    keys.collect! { |l| l.to_s }
    r = {}
    remain = []
    keys.each do |i|
      if local_meta_cache[i]
        r[i] = local_meta_cache[i]
      else
        remain << i
      end
    end
    r2 = super *remain
    local_meta_cache.merge!(r2)
    r.merge!(r2)
    r
  end

  private 
  def local_meta_cache
    @meta_cache||={}
  end
end
