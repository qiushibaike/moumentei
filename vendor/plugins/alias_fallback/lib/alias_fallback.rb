module AliasFallback
  def alias_fallback(method, fallback_method = nil, &block)
    original_method = "original_#{method}"
    alias_method original_method, method
    if fallback_method
      define_method(method) do |*args|
        __send__(original_method, *args) || __send__(fallback_method, *args)
      end
    else
      define_method(method) do |*args|
        __send__(original_method, *args) || block.call(self, *args)
      end
    end
  end
end

Module.send :include, AliasFallback