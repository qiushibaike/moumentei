module OpenFlashChart

  class LineStyle < LineBase
    def initialize on, off, args={}
      super args
      @on    = on
      @off   = off
      @style = "dash"
    end
  end

end
