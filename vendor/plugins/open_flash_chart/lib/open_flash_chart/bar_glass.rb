module OpenFlashChart

  class BarOnShow < Base
    def initialize(type, cascade, delay)
      @type    = type
      @cascade = cascade.to_f
      @delay   = delay.to_f
    end
  end

  class BarGlass < BarBase
    def initialize args={}
      super
      @type = "bar_glass"      
    end
  end

  class BarCylinder < BarBase
    def initialize args={}
      super
      @type = "bar_cylinder"      
    end
  end

  class BarCylinderOutline < BarBase
    def initialize args={}
      super
      @type = "bar_cylinder_outline"      
    end
  end

  class BarRoundedGlass < BarBase
    def initialize args={}
      super
      @type = "bar_rounded_glass"      
    end
  end

  class BarRound < BarBase
    def initialize args={}
      super
      @type = "bar_round"      
    end
  end

  class BarDome < BarBase
    def initialize args={}
      super
      @type = "bar_dome"      
    end
  end

  class BarRound3d < BarBase
    def initialize args={}
      super
      @type = "bar_round3d"      
    end
  end

  class BarGlassValue < Base
    def initialize(top, args={})
      @top = top
      super args
    end
  end

end
