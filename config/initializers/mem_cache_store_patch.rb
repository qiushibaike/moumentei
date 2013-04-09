# -*- encoding : utf-8 -*-
module ActiveSupport::Cache
  class MemCacheStore
    def append(key, value)
      @data.append(key, value) == Response::STORED
    end
  end
end
