if false && Rails.env.production
class ActiveRecord::Base
  class << self
    alias_method :orig_inherited, :inherited
    def inherited(child)
      orig_inherited(child)
      child.data_fabric :replicated => true
    end
  end
end
end
