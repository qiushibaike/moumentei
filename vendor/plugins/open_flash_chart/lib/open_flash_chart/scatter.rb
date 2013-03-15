module OpenFlashChart

  class ScatterValue < Base
    def initialize(x,y,dot_size=-1, args={})
      super args
      @x = x
      @y = y
      @dot_size = dot_size if dot_size.to_i > 0      
    end
  end

  class Scatter < Base
    def initialize(colour, dot_style=nil, args={})
      @type = "scatter"
      @colour = colour
      @dot_style = dot_style
      @values = []
      super args
    end
  end

end
