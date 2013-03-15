module OpenFlashChart
  class YAxisLabel < Base
    def initialize(y, text)
      @y = y
      @text = text
    end

    def set_vertical
      @rotate = "vertical"
    end
  end
end
