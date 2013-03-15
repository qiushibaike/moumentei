# The controller for serving/cacheing theme content...
class ThemeController < ActionController::Base
  #class_inheritable_attribute
  #caches_page :stylesheets, :javascripts, :images

  def stylesheets
    render_theme_item(:stylesheets, joined_filename, params[:theme])
  end

  def javascripts
    render_theme_item(:javascripts, joined_filename, params[:theme])
  end

  def images
    render_theme_item(:images, joined_filename, params[:theme])
  end

  def error
    render :nothing => true, :status => 404
  end

  private

  def render_theme_item(type, file, theme, mime = mime_for(file))
    file_path = "#{Theme.path_to_theme(theme)}/#{type}/#{file}"
    expires_in 1.hour, 'max-stale' => 5.hours, :public => true
    if file.split(%r{[\\/]}).include?("..") || !File.exists?(file_path) || file.blank?
      render :text => "Not Found", :status => 404
      return
    else
      if stale?(:last_modified => File.mtime(file_path), :public => true)
        send_file file_path, :type => mime, :disposition => 'inline'#, :stream => false
      end
    end
  end

  def joined_filename
    params[:filename].join '/'
  end

  def mime_for(filename)
    case filename.downcase
    when /\.js$/
      'text/javascript'
    when /\.css$/
      'text/css'
    when /\.gif$/
      'image/gif'
    when /(\.jpg|\.jpeg)$/
      'image/jpeg'
    when /\.png$/
      'image/png'
    when /\.swf$/
      'application/x-shockwave-flash'
    else
      'application/binary'
    end
  end
end
