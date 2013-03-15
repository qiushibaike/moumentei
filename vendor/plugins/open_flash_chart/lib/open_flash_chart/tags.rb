module OpenFlashChart
  class OFCTags < Base
    def initialize args={}
      super args
      @type   = 'tags'
      @values = []
    end

    def font(font, size)
      @font = font
      @font_size = size
    end

    def padding(x,y)
      @pad_x = x
      @pad_y = y
    end

    def align_x_center
      @align_x = "center"
    end

    def align_x_left
      @align_x = "left"
    end

    def align_x_right
      @align_x = "right"
    end

    def align_y_above
      @align_y = "above"
    end

    def align_y_below
      @align_y = "below"
    end

    def align_y_center
      @align_y = "center"
    end

    def style(bold, underline, border, alpha)
      @bold = bold
      @border = border
      @underline = underline
      @alpha = alpha
    end

    def append_tag(tag)
      @values << tag
    end
  end

  class OFCTag < Base
    def initialize(x,y, args={})
      super args
      @x = x
      @y = y
    end
  end
end
