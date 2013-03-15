module OpenFlashChart

  class BarStack < BarBase
    def initialize args={}
      super
      @type = "bar_stack"      
    end

    alias_method :append_stack, :append_value
  end

  class BarStackValue < Base
    def initialize(val,colour, args={})
      @val    = val
      @colour = colour
      super(args)
    end
  end

  class BarStackKey < Base
    def initialize(colour, text, font_size, args={})
      @colour    = colour
      @text      = text
      @font_size = font_size
      super(args)
    end
  end

end
