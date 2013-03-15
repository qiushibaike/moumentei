module OpenFlashChart

  class DotBase < Base
    def initialize type, value=nil, args={}
      super args
      @type  = type
      @value = value if value
    end

    def position=(x, y)
      @x = x
      @y = y
    end

    def size=(size)
      @dot_size = size        
    end
  end

  class HollowDot < DotBase
    def initialize(value=nil, args={})
      super 'hollow_dot', value, args
    end
  end
  
  class Star < DotBase
    def initialize(value=nil, args={})
      super 'star', value, args
    end
  end
  
  class Bow < DotBase
    def initialize(value=nil, args={})
      super 'bow', value, args
    end
  end
  
  class Anchor < DotBase
    def initialize(value=nil, args={})
      super 'anchor', value, args
    end
  end
  
  class Dot < DotBase
    def initialize(value=nil, args={})
      super 'dot', value, args
    end
  end
  
  class SolidDot < DotBase
    def initialize(value=nil, args={})
      super 'solid-dot', value, args
    end
  end
end
