module ThemeSupport
  module ControllerExtensions
    def self.included(klass)
      klass.class_eval do
        helper_method :current_theme
        extend ClassMethods
        include InstanceMethods
      end
      #klass.send :alias_method, :theme_support_active_layout, :active_layout
    end
    
    module ClassMethods
      # Use this in your controller just like the <tt>layout</tt> macro.
      # Example:
      #
      #  theme 'theme_name'
      #
      # -or-
      #
      #  theme :get_theme
      #
      #  def get_theme
      #    'theme_name'
      #  end
      def theme(theme_name, conditions = {})
        # TODO: Allow conditions... (?)
        write_inheritable_attribute "theme", theme_name
      end
    end
    
    module InstanceMethods
      #attr_accessor :current_theme
      #attr_accessor :force_liquid_template
      def current_theme
        unless @active_theme
          theme = self.class.read_inheritable_attribute("theme")
          @active_theme = case theme
          when Symbol then send(theme)
          when Proc   then theme.call(self)
          when String then theme
          end
          logger.debug{"select theme: #{@active_theme}"}
        end

        @active_theme
      end
      alias theme_name current_theme
        
      def current_theme=(theme)
        @active_theme = theme
      end

      def render(*args)
        if t = current_theme
          theme_path = File.join(RAILS_ROOT, "themes", t, "views")
          prepend_view_path(theme_path) if (not view_paths.include?(theme_path)) and File.exists?(theme_path)
        end
        super
      end
    end
  end
end
