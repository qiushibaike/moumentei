# -*- encoding : utf-8 -*-
module Article::MetadataAspect
	module ClassMethods
		def meta_field(key)
      key = key.to_sym
      add_meta_field(key)
      define_method(key) do
        get_metadata(key)
      end
      define_method("#{key}=") do |value|
        set_metadata(key, value)
      end
    end
    
    if Class.respond_to?(:class_attribute)
      def add_meta_field(key)
        self.meta_fields << key
      end
    else
      def add_meta_field(key)
        write_inheritable_array(:meta_fields, [key])
      end
      def meta_fields
        read_inheritable_attrbiutes(:meta_fields)
      end
    end
    private :add_meta_field
	end
	
	module InstanceMethods
		def get_metadata(key)
      metadatas.find_by_key(key.to_s).try(:value)
    end
    
    def get_metadatas(*keys)
      m = metadatas.find_all_by_key(keys.flatten)
      Hash[*m.collect{|i|[i.key, i.value]}.flatten]
    end
    
    def set_metadata(key, value)
      m = metadatas.find_or_initialize_by_key(key.to_s)
      m.lock!
      m.value = value
      m.save
    end
	end
	
	def self.included(receiver)
		receiver.extend         ClassMethods
		receiver.send :include, InstanceMethods
    
    receiver.class_eval do 
      has_many :metadatas
      include MetadataRemoteCache
      include MetadataLocalCache
      if respond_to?(:class_attribute)
        class_attribute :meta_fields 
        self.meta_fields = []
      end
    end
	end
end
