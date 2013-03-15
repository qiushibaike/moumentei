module OpenFlashChart

  class LineBase < Base
    def initialize args={}
      super
      @type = "line"
      @text = "Page Views"
      @font_size = 10
      @values = []
    end

    def loop
      @loop = true
    end
  end

end
