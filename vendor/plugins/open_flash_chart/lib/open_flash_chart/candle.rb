module OpenFlashChart

  class Candle < Base
    def initialize(colour, negative_colour, args={})
      @colour = colour
      @negative_colour = negative_colour
      super args
      @type = "candle"   
    end
  end
  
  class CandleValue < Base
    def initialize( high, open, close, low, args={} )
      @top = open
      @bottom = close
      @low = low
      @high = high
      super args
    end
  end

end
