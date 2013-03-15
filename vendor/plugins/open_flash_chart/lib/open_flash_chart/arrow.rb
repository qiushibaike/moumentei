module OpenFlashChart

  class AreaLine
    def initialize(x, y, a, b, colour, barb_length=10)
      @type   = "arrow"
      @start  = {:x => x, :y => y}
      @end    = {:x => a, :y => b}
      @colour = colour
      @barb_length = barb_length
    end
  end

end
