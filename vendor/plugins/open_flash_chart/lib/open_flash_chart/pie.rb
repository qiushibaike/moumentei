module OpenFlashChart

  class PieValue < Base
    def initialize(value, label, args={})
      super args
      @value = value
      @label = label      
      @animate = []
    end

    def set_label(label, label_color, font_size)
      self.label        = label
      self.label_colour = label_color
      self.font_size    = font_size
    end

    def on_click(event)
      @on_click = event
    end

    def add_animation animation
      @animate ||= []
      @animate << animation
      return self
    end
  end

  class BasePieAnimation < Base; end

  class PieFade < BasePieAnimation
    def initialize args={} 
      @type = "fade"
      super
    end
  end

  class PieBounce < BasePieAnimation
    def initialize distance, args={} 
      @type = "bounce"
      @distance = distance
      super
    end
  end

  class Pie < Base
    def initialize args={}
      @type = "pie"
      @colours = []
      super
    end

    def set_animate bool
      self.add_animation PieFade.new if bool
    end

    def add_animation animation
      @animate ||= []
      @animate << animation
      return self
    end

    def set_gradient_fill
      @gradient_fill = true      
    end

    def set_no_labels
      @no_labels = true
    end

    def on_click(event)
      @on_click = event
    end
  end

end
