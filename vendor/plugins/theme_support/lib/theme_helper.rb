# this is here so that Rails doesn't complain about a missing default helper...
module ThemeHelper

  # returns the public path to a theme stylesheet
  def theme_stylesheet_path( source=nil, theme=nil )
    theme = theme || controller.current_theme
    compute_public_path(source || "theme", "themes/#{theme}/stylesheets", 'css')
  end

  # returns the path to a theme image
  def theme_image_path( source, theme=nil )
    theme = theme || controller.current_theme
    compute_public_path(source, "themes/#{theme}/images", 'png')
  end

  # returns the path to a theme javascript
  # def theme_javascript_path( source, theme=nil )
  #   theme = theme || controller.current_theme
  #   compute_public_path(source, "themes/#{theme}/javascript", 'js')
  # end

  # This tag it will automatially include theme specific css files
  def theme_stylesheet_link_tag(*sources)
    sources.uniq!
    options = sources.last.is_a?(Hash) ? sources.pop.stringify_keys : { }
    themed_sources = sources.collect { |source| theme_stylesheet_path(source) }
    stylesheet_link_tag(themed_sources)
  end

  # This tag will return a theme-specific IMG
  def theme_image_tag(source, options = {})
    options.symbolize_keys

    options[:src] = theme_image_path(source)
    options[:alt] ||= File.basename(options[:src], '.*').split('.').first.capitalize

    if options[:size]
      options[:width], options[:height] = options[:size].split("x")
      options.delete :size
    end

    tag("img", options)
  end

  # This tag can be used to return theme specific javascript files
  def theme_javascript_include_tag(*sources)
    options = sources.extract_options!.stringify_keys
    sources.flatten!
    if sources.include?(:defaults)
      pre_default_sources = sources[0..(sources.index(:defaults))]
      post_default_sources = sources[(sources.index(:defaults) + 1)..sources.length]
      sources = pre_default_sources + @@javascript_default_sources.dup + post_default_sources
      sources.delete(:defaults)

      sources << "application" if defined?(Rails.root) && File.exists?("#{Rails.root}/public/javascripts/application.js")
    end
    concat  = options.delete("concat")
    cache   = concat || options.delete("cache")
    recursive = options.delete("recursive")
    theme_name = controller.current_theme
    if concat || (ActionController::Base.perform_caching && cache)
      themed_sources = sources.collect do |source|
        source = "#{source}.js" unless source =~ /\./
        File.join("#{RAILS_ROOT}/themes/#{theme_name}", "javascripts", source)
      end

      joined_javascript_name = (cache == true ? theme_name : cache) + ".js"
      joined_javascript_path = File.join('themes', theme_name, 'javascripts', joined_javascript_name)
      #controller.logger.info(themed_sources.inspect)
      #controller.logger.info(joined_javascript_path.inspect)
      #unless ActionController::Base.perform_caching #&& File.exists?(joined_javascript_path)
      write_theme_asset_file_contents(File.join(RAILS_ROOT, 'public', joined_javascript_path), themed_sources)
      #end
      javascript_src_tag("/#{joined_javascript_path}", options)
    else
      themed_sources = sources.collect { |source| compute_public_path(source, "themes/#{theme_name}/javascripts", 'js') }
      javascript_include_tag(themed_sources, options)
    end
    #options['cache']

    #
  end
protected
  def write_theme_asset_file_contents(joined_asset_path, asset_paths)
    #RAILS_DEFAULT_LOGGER.info joined_asset_path
    FileUtils.mkdir_p(File.dirname(joined_asset_path))
    File.open(joined_asset_path, "w+") do |cache|
      asset_paths.each { |path|
        cache.write(File.read(path))
        cache.write("\n\n")
      }
    end

    # Set mtime to the latest of the combined files to allow for
    # consistent ETag without a shared filesystem.
    mt = asset_paths.map { |p| File.mtime(p) }.max
    File.utime(mt, mt, joined_asset_path)
  end
end
