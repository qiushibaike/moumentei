module OpenFlashChart
  class SStar < Star
    def initialize(colour, size, args={})
      super args
      @colour = colour
      @size   = size
    end
  end

  class SBox < Anchor
    def initialize(colour, size, args={})
      super args
      @colour   = colour
      @size     = size
      @sides    = 4
      @rotation = 45
    end
  end

  class SHollowDot < HollowDot
    def initialize(colour, size, args={})
      super args
      @colour = colour
      @size   = size
    end
  end
end
