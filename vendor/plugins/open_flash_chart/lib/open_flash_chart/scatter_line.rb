module OpenFlashChart

  class ScatterLine < Base
    def initialize(colour, width, args={})
      super args
      @type = 'scatter_line'
      @colour = colour
      @width = width      
    end

    def set_step_horizonal
      @stepgraph = 'horizontal'
    end

    def set_step_vertical
      @stepgraph = 'vertical'
    end
  end

end
