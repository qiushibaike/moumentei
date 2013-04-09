# -*- encoding : utf-8 -*-
# cache metadata in shared cache store
module Article::MetadataRemoteCache
  def get_metadata(key)
    Rails.cache.fetch([self, key], :raw => raw) do
      super
    end
  end
  
  def set_metadata(key, value)
    Rails.cache.write([self, key], value, :raw => raw) if super
  end
end
