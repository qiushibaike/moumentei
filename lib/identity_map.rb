# a simple identity map implementation
module IdentityMap
  def self.included(base)
    base.extend ClassMethods
  end
  module ClassMethods
    def load_identity(id)
      @identity_map ||= {}
#      ap @identity_map
      @identity_map[id.to_s] ||= yield id
    end
    def find_one id, options
      load_identity( id ) do
        super id, options
      end
    end
    def find_some ids, options
      rest = []
      from_identity = []
      ids.each do |i|
        from_identity << load_identity(i){|id|rest<<id;nil}
      end

      if rest.size > 0
        from_identity + super( rest, options )
      else
        from_identity
      end
    end
    def instantiate(record)
      pk = primary_key
      id = record[pk]
      load_identity(id){super record}
    end
  end
end