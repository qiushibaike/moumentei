require 'preferences/preference_definition'

# Adds support for defining preferences on ActiveRecord models.
# 
# == Saving preferences
# 
# Preferences are not automatically saved when they are set.  You must save
# the record that the preferences were set on.
# 
# For example,
# 
#   class User < ActiveRecord::Base
#     preference :notifications
#   end
#   
#   u = User.new(:login => 'admin', :prefers_notifications => false)
#   u.save!
#   
#   u = User.find_by_login('admin')
#   u.attributes = {:prefers_notifications => true}
#   u.save!
# 
# == Validations
# 
# Since the generated accessors for a preference allow the preference to be
# treated just like regular ActiveRecord attributes, they can also be
# validated against in the same way.  For example,
# 
#   class User < ActiveRecord::Base
#     preference :color, :string
#     
#     validates_presence_of :preferred_color
#     validates_inclusion_of :preferred_color, :in => %w(red green blue)
#   end
#   
#   u = User.new
#   u.valid?                        # => false
#   u.errors.on(:preferred_color)   # => "can't be blank"
#   
#   u.preferred_color = 'white'
#   u.valid?                        # => false
#   u.errors.on(:preferred_color)   # => "is not included in the list"
#   
#   u.preferred_color = 'red'
#   u.valid?                        # => true
module Preferences
  module MacroMethods
    # Defines a new preference for all records in the model.  By default,
    # preferences are assumed to have a boolean data type, so all values will
    # be typecasted to true/false based on ActiveRecord rules.
    # 
    # Configuration options:
    # * <tt>:default</tt> - The default value for the preference. Default is nil.
    # * <tt>:group_defaults</tt> - Defines the default values to use for various
    #   groups.  This should map group_name -> defaults.  For ActiveRecord groups,
    #   use the class name. 
    # 
    # == Examples
    # 
    # The example below shows the various ways to define a preference for a
    # particular model.
    # 
    #   class User < ActiveRecord::Base
    #     preference :notifications, :default => false
    #     preference :color, :string, :default => 'red', :group_defaults => {:car => 'black'}
    #     preference :favorite_number, :integer
    #     preference :data, :any # Allows any data type to be stored
    #   end
    # 
    # All preferences are also inherited by subclasses.
    # 
    # == Associations
    # 
    # After the first preference is defined, the following associations are
    # created for the model:
    # * +stored_preferences+ - A collection of all the custom preferences
    #   specified for a record.  This will not include default preferences
    #   unless they have been explicitly set.
    # 
    # == Named scopes
    # 
    # In addition to the above associations, the following named scopes get
    # generated for the model:
    # * +with_preferences+ - Finds all records with a given set of preferences
    # * +without_preferences+ - Finds all records without a given set of preferences
    # 
    # In addition to utilizing preferences stored in the database, each of the
    # above scopes also take into account the defaults that have been defined
    # for each preference.
    # 
    # Example:
    # 
    #   User.with_preferences(:notifications => true)
    #   User.with_preferences(:notifications => true, :color => 'blue')
    #   
    #   # Searching with group preferences
    #   car = Car.find(:first)
    #   User.with_preferences(car => {:color => 'blue'})
    #   User.with_preferences(:notifications => true, car => {:color => 'blue'})
    # 
    # == Generated accessors
    # 
    # In addition to calling <tt>prefers?</tt> and +preferred+ on a record,
    # you can also use the shortcut accessor methods that are generated when a
    # preference is defined.  For example,
    # 
    #   class User < ActiveRecord::Base
    #     preference :notifications
    #   end
    # 
    # ...generates the following methods:
    # * <tt>prefers_notifications?</tt> - Whether a value has been specified, i.e. <tt>record.prefers?(:notifications)</tt>
    # * <tt>prefers_notifications</tt> - The actual value stored, i.e. <tt>record.prefers(:notifications)</tt>
    # * <tt>prefers_notifications=(value)</tt> - Sets a new value, i.e. <tt>record.write_preference(:notifications, value)</tt>
    # * <tt>prefers_notifications_changed?</tt> - Whether the preference has unsaved changes
    # * <tt>prefers_notifications_was</tt> - The last saved value for the preference
    # * <tt>prefers_notifications_change</tt> - A list of [original_value, new_value] if the preference has changed
    # * <tt>prefers_notifications_will_change!</tt> - Forces the preference to get updated
    # * <tt>reset_prefers_notifications!</tt> - Reverts any unsaved changes to the preference
    # 
    # ...and the equivalent +preferred+ methods:
    # * <tt>preferred_notifications?</tt>
    # * <tt>preferred_notifications</tt>
    # * <tt>preferred_notifications=(value)</tt>
    # * <tt>preferred_notifications_changed?</tt>
    # * <tt>preferred_notifications_was</tt>
    # * <tt>preferred_notifications_change</tt>
    # * <tt>preferred_notifications_will_change!</tt>
    # * <tt>reset_preferred_notifications!</tt>
    # 
    # Notice that there are two tenses used depending on the context of the
    # preference.  Conventionally, <tt>prefers_notifications?</tt> is better
    # for accessing boolean preferences, while +preferred_color+ is better for
    # accessing non-boolean preferences.
    # 
    # Example:
    # 
    #   user = User.find(:first)
    #   user.prefers_notifications?         # => false
    #   user.prefers_notifications          # => false
    #   user.preferred_color?               # => true
    #   user.preferred_color                # => 'red'
    #   user.preferred_color = 'blue'       # => 'blue'
    #   
    #   user.prefers_notifications = true
    #   
    #   car = Car.find(:first)
    #   user.preferred_color = 'red', car   # => 'red'
    #   user.preferred_color(car)           # => 'red'
    #   user.preferred_color?(car)          # => true
    #   
    #   user.save!  # => true
    def preference(name, *args)
      unless included_modules.include?(InstanceMethods)
        class_inheritable_hash :preference_definitions
        self.preference_definitions = {}
        
        has_many :stored_preferences, :as => :owner, :class_name => 'Preference'
        
        after_save :update_preferences
        
        # Named scopes
        named_scope :with_preferences, lambda {|preferences| build_preference_scope(preferences)}
        named_scope :without_preferences, lambda {|preferences| build_preference_scope(preferences, true)}
        
        extend Preferences::ClassMethods
        include Preferences::InstanceMethods
      end
      
      # Create the definition
      name = name.to_s
      definition = PreferenceDefinition.new(name, *args)
      self.preference_definitions[name] = definition
      
      # Create short-hand accessor methods, making sure that the name
      # is method-safe in terms of what characters are allowed
      name = name.gsub(/[^A-Za-z0-9_-]/, '').underscore
      
      # Query lookup
      define_method("preferred_#{name}?") do |*group|
        preferred?(name, group.first)
      end
      alias_method "prefers_#{name}?", "preferred_#{name}?"
      
      # Reader
      define_method("preferred_#{name}") do |*group|
        preferred(name, group.first)
      end
      alias_method "prefers_#{name}", "preferred_#{name}"
      
      # Writer
      define_method("preferred_#{name}=") do |*args|
        write_preference(*args.flatten.unshift(name))
      end
      alias_method "prefers_#{name}=", "preferred_#{name}="
      
      # Changes
      define_method("preferred_#{name}_changed?") do |*group|
        preference_changed?(name, group.first)
      end
      alias_method "prefers_#{name}_changed?", "preferred_#{name}_changed?"
      
      define_method("preferred_#{name}_was") do |*group|
        preference_was(name, group.first)
      end
      alias_method "prefers_#{name}_was", "preferred_#{name}_was"
      
      define_method("preferred_#{name}_change") do |*group|
        preference_change(name, group.first)
      end
      alias_method "prefers_#{name}_change", "preferred_#{name}_change"
      
      define_method("preferred_#{name}_will_change!") do |*group|
        preference_will_change!(name, group.first)
      end
      alias_method "prefers_#{name}_will_change!", "preferred_#{name}_will_change!"
      
      define_method("reset_preferred_#{name}!") do |*group|
        reset_preference!(name, group.first)
      end
      alias_method "reset_prefers_#{name}!", "reset_preferred_#{name}!"
      
      definition
    end
  end
  
  module ClassMethods #:nodoc:
    # Generates the scope for looking under records with a specific set of
    # preferences associated with them.
    # 
    # Note thate this is a bit more complicated than usual since the preference
    # definitions aren't in the database for joins, defaults need to be accounted
    # for, and querying for the the presence of multiple preferences requires
    # multiple joins.
    def build_preference_scope(preferences, inverse = false)
      joins = []
      statements = []
      values = []
      
      # Flatten the preferences for easier processing
      preferences = preferences.inject({}) do |result, (group, value)|
        if value.is_a?(Hash)
          value.each {|preference, value| result[[group, preference]] = value}
        else
          result[[nil, group]] = value
        end
        result
      end
      
      preferences.each do |(group, preference), value|
        group_id, group_type = Preference.split_group(group)
        preference = preference.to_s
        definition = preference_definitions[preference.to_s]
        value = definition.type_cast(value)
        is_default = definition.default_value(group_type) == value
        
        table = "preferences_#{group_id}_#{group_type}_#{preference}"
        
        # Since each preference is a different record, they need their own
        # join so that the proper conditions can be set
        joins << "LEFT JOIN preferences AS #{table} ON #{table}.owner_id = #{table_name}.#{primary_key} AND " + sanitize_sql(
          "#{table}.owner_type" => base_class.name.to_s,
          "#{table}.group_id" => group_id,
          "#{table}.group_type" => group_type,
          "#{table}.name" => preference
        )
        
        if inverse
          statements << "#{table}.id IS NOT NULL AND #{table}.value " + (value.nil? ? ' IS NOT NULL' : ' != ?') + (!is_default ? " OR #{table}.id IS NULL" : '')
        else
          statements << "#{table}.id IS NOT NULL AND #{table}.value " + (value.nil? ? ' IS NULL' : ' = ?') + (is_default ? " OR #{table}.id IS NULL" : '')
        end
        values << value unless value.nil?
      end
      
      sql = statements.map! {|statement| "(#{statement})"} * ' AND '
      {:joins => joins, :conditions => values.unshift(sql)}
    end
  end
  
  module InstanceMethods
    def self.included(base) #:nodoc:
      base.class_eval do
        alias_method :prefs, :preferences
      end
    end
    
    # Finds all preferences, including defaults, for the current record.  If
    # looking up custom group preferences, then this will include all default
    # preferences within that particular group as well.
    # 
    # == Examples
    # 
    # A user with no stored values:
    # 
    #   user = User.find(:first)
    #   user.preferences
    #   => {"language"=>"English", "color"=>nil}
    #   
    # A user with stored values for a particular group:
    # 
    #   user.preferred_color = 'red', :cars
    #   user.preferences(:cars)
    #   => {"language=>"English", "color"=>"red"}
    def preferences(group = nil)
      preferences = preferences_group(group)
      
      unless preferences_group_loaded?(group)
        group_id, group_type = Preference.split_group(group)
        find_preferences(:group_id => group_id, :group_type => group_type).each do |preference|
          preferences[preference.name] = preference.value unless preferences.include?(preference.name)
        end
        
        # Add defaults
        preference_definitions.each do |name, definition|
          preferences[name] = definition.default_value(group_type) unless preferences.include?(name)
        end
      end
      
      preferences.inject({}) do |typed_preferences, (name, value)|
        typed_preferences[name] = value.nil? ? value : preference_definitions[name].type_cast(value)
        typed_preferences
      end
    end
    
    # Queries whether or not a value is present for the given preference.
    # This is dependent on how the value is type-casted.
    # 
    # == Examples
    # 
    #   class User < ActiveRecord::Base
    #     preference :color, :string, :default => 'red'
    #   end
    #   
    #   user = User.create
    #   user.preferred(:color)              # => "red"
    #   user.preferred?(:color)             # => true
    #   user.preferred?(:color, 'cars')     # => true
    #   user.preferred?(:color, Car.first)  # => true
    #   
    #   user.write_preference(:color, nil)
    #   user.preferred(:color)              # => nil
    #   user.preferred?(:color)             # => false
    def preferred?(name, group = nil)
      name = name.to_s
      assert_valid_preference(name)
      
      value = preferred(name, group)
      preference_definitions[name].query(value)
    end
    alias_method :prefers?, :preferred?
    
    # Gets the actual value stored for the given preference, or the default
    # value if nothing is present.
    # 
    # == Examples
    # 
    #   class User < ActiveRecord::Base
    #     preference :color, :string, :default => 'red'
    #   end
    #   
    #   user = User.create
    #   user.preferred(:color)            # => "red"
    #   user.preferred(:color, 'cars')    # => "red"
    #   user.preferred(:color, Car.first) # => "red"
    #   
    #   user.write_preference(:color, 'blue')
    #   user.preferred(:color)            # => "blue"
    def preferred(name, group = nil)
      name = name.to_s
      assert_valid_preference(name)
      
      if preferences_group(group).include?(name)
        # Value for this group/name has been written, but not saved yet:
        # grab from the pending values
        value = preferences_group(group)[name]
      else
        # Grab the first preference; if it doesn't exist, use the default value
        group_id, group_type = Preference.split_group(group)
        preference = find_preferences(:name => name, :group_id => group_id, :group_type => group_type).first unless preferences_group_loaded?(group)
        
        value = preference ? preference.value : preference_definitions[name].default_value(group_type)
        preferences_group(group)[name] = value
      end
      
      definition = preference_definitions[name]
      value = definition.type_cast(value) unless value.nil?
      value
    end
    alias_method :prefers, :preferred
    
    # Sets a new value for the given preference.  The actual Preference record
    # is *not* created until this record is saved.  In this way, preferences
    # act *exactly* the same as attributes.  They can be written to and
    # validated against, but won't actually be written to the database until
    # the record is saved.
    # 
    # == Examples
    # 
    #   user = User.find(:first)
    #   user.write_preference(:color, 'red')              # => "red"
    #   user.save!
    #   
    #   user.write_preference(:color, 'blue', Car.first)  # => "blue"
    #   user.save!
    def write_preference(name, value, group = nil)
      name = name.to_s
      assert_valid_preference(name)
      
      preferences_changed = preferences_changed_group(group)
      if preferences_changed.include?(name)
        old = preferences_changed[name]
        preferences_changed.delete(name) unless preference_value_changed?(name, old, value)
      else
        old = clone_preference_value(name, group)
        preferences_changed[name] = old if preference_value_changed?(name, old, value)
      end
      
      value = convert_number_column_value(value) if preference_definitions[name].number?
      preferences_group(group)[name] = value
      
      value
    end
    
    # Whether any attributes have unsaved changes.
    # 
    # == Examples
    # 
    #   user = User.find(:first)
    #   user.preferences_changed?                   # => false
    #   user.write_preference(:color, 'red')
    #   user.preferences_changed?                   # => true
    #   user.save
    #   user.preferences_changed?                   # => false
    #   
    #   # Groups
    #   user.preferences_changed?(:car)             # => false
    #   user.write_preference(:color, 'red', :car)
    #   user.preferences_changed(:car)              # => true
    def preferences_changed?(group = nil)
      !preferences_changed_group(group).empty?
    end
    
    # A list of the preferences that have unsaved changes.
    # 
    # == Examples
    # 
    #   user = User.find(:first)
    #   user.preferences_changed                    # => []
    #   user.write_preference(:color, 'red')
    #   user.preferences_changed                    # => ["color"]
    #   user.save
    #   user.preferences_changed                    # => []
    #   
    #   # Groups
    #   user.preferences_changed(:car)              # => []
    #   user.write_preference(:color, 'red', :car)
    #   user.preferences_changed(:car)              # => ["color"]
    def preferences_changed(group = nil)
      preferences_changed_group(group).keys
    end
    
    # A map of the preferences that have changed in the current object.
    # 
    # == Examples
    # 
    #   user = User.find(:first)
    #   user.preferred(:color)                      # => nil
    #   user.preference_changes                     # => {}
    #   
    #   user.write_preference(:color, 'red')
    #   user.preference_changes                     # => {"color" => [nil, "red"]}
    #   user.save
    #   user.preference_changes                     # => {}
    #   
    #   # Groups
    #   user.preferred(:color, :car)                # => nil
    #   user.preference_changes(:car)               # => {}
    #   user.write_preference(:color, 'red', :car)
    #   user.preference_changes(:car)               # => {"color" => [nil, "red"]}
    def preference_changes(group = nil)
      preferences_changed(group).inject({}) do |changes, preference|
        changes[preference] = preference_change(preference, group)
        changes
      end
    end
    
    # Reloads the pereferences of this object as well as its attributes
    def reload(*args) #:nodoc:
      result = super
      
      @preferences.clear if @preferences
      @preferences_changed.clear if @preferences_changed
      
      result
    end
    
    private
      # Asserts that the given name is a valid preference in this model.  If it
      # is not, then an ArgumentError exception is raised.
      def assert_valid_preference(name)
        raise(ArgumentError, "Unknown preference: #{name}") unless preference_definitions.include?(name)
      end
      
      # Gets the set of preferences identified by the given group
      def preferences_group(group)
        @preferences ||= {}
        @preferences[group.is_a?(Symbol) ? group.to_s : group] ||= {}
      end
      
      # Determines whether the given group of preferences has already been
      # loaded from the database
      def preferences_group_loaded?(group)
        preference_definitions.length == preferences_group(group).length
      end
      
      # Generates a clone of the current value stored for the preference with
      # the given name / group
      def clone_preference_value(name, group)
        value = preferred(name, group)
        value.duplicable? ? value.clone : value
      rescue TypeError, NoMethodError
        value
      end
      
      # Keeps track of all preferences that have been changed so that they can
      # be properly updated in the database.  Maps group -> preference -> value.
      def preferences_changed_group(group)
        @preferences_changed ||= {}
        @preferences_changed[group.is_a?(Symbol) ? group.to_s : group] ||= {}
      end
      
      # Determines whether a preference changed in the given group
      def preference_changed?(name, group)
        preferences_changed_group(group).include?(name)
      end
      
      # Builds an array of [original_value, new_value] for the given preference.
      # If the perference did not change, this will return nil.
      def preference_change(name, group)
        [preferences_changed_group(group)[name], preferred(name, group)] if preference_changed?(name, group)
      end
      
      # Gets the last saved value for the given preference
      def preference_was(name, group)
        preference_changed?(name, group) ? preferences_changed_group(group)[name] : preferred(name, group)
      end
      
      # Forces the given preference to be saved regardless of whether the value
      # is actually diferent
      def preference_will_change!(name, group)
        preferences_changed_group(group)[name] = clone_preference_value(name, group)
      end
      
      # Reverts any unsaved changes to the given preference
      def reset_preference!(name, group)
        write_preference(name, preferences_changed_group(group)[name], group) if preference_changed?(name, group)
      end
      
      # Determines whether the old value is different from the new value for the
      # given preference.  This will use the typecasted value to determine
      # equality.
      def preference_value_changed?(name, old, value)
        definition = preference_definitions[name]
        if definition.type == :integer && (old.nil? || old == 0)
          # For nullable numeric columns, NULL gets stored in database for blank (i.e. '') values.
          # Hence we don't record it as a change if the value changes from nil to ''.
          # If an old value of 0 is set to '' we want this to get changed to nil as otherwise it'll
          # be typecast back to 0 (''.to_i => 0)
          value = nil if value.blank?
        else
          value = definition.type_cast(value)
        end
        
        old != value
      end
      
      # Updates any preferences that have been changed/added since the record
      # was last saved
      def update_preferences
        if @preferences_changed
          @preferences_changed.each do |group, preferences|
            group_id, group_type = Preference.split_group(group)
            
            preferences.keys.each do |name|
              # Find an existing preference or build a new one
              attributes = {:name => name, :group_id => group_id, :group_type => group_type}
              preference = find_preferences(attributes).first || stored_preferences.build(attributes)
              preference.value = preferred(name, group)
              preference.save!
            end
          end
          
          @preferences_changed.clear
        end
      end
      
      # Finds all stored preferences with the given attributes.  This will do a
      # smart lookup by looking at the in-memory collection if it was eager-
      # loaded.
      def find_preferences(attributes)
        if stored_preferences.loaded?
          stored_preferences.select do |preference|
            attributes.all? {|attribute, value| preference[attribute] == value} 
          end
        else
          stored_preferences.find(:all, :conditions => attributes)
        end
      end
  end
end

ActiveRecord::Base.class_eval do
  extend Preferences::MacroMethods
end
