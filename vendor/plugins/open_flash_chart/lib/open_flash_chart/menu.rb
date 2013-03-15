module OpenFlashChart

  class MenuItem < Base
    def initialize(text, javascript_function_name, args={})
      @type  = "text"
      @text  = text
      @javascript_function_name = javascript_function_name
    end
  end

  class MenuItemCamera < Base
    def initialize text, javascript_function_name
      @type = "camera-icon"
      @text = text
      @javascript_function_name = javascript_function_name
    end
  end

  class Menu < Base
    def initialize colour, outline_colour
      @values = []
      @colour = colour
      @outline_colour = outline_colour
    end
  end
end
