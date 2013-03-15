module OpenFlashChart

  class LineOnShow < Base
    def initialize(type, cascade, delay)
      @type    = type
      @cascade = cascade.to_F
      @delay   = delay.to_f
    end
  end

  class Line < LineBase
    def initialize args={}
      super
      @type = "line"      
      @values = []
    end

    def set_default_dot_style(style)
      @dot_style = style
    end
  end

end
