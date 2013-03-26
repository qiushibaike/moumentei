# -*- encoding : utf-8 -*-
module OpenFlashChart

  class RadarAxis < Base
    def initialize(max, args={})
      super args
      @max = max      
    end
  end

end
