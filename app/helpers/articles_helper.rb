# -*- encoding : utf-8 -*-
module ArticlesHelper
  def navigator
    
  end

  def show_tags(article, current_tag = nil)
    tag = article.tag_line
    group = @group || article.group
    current_tag ||= @current_tag
    return if tag.blank?
    m = {}
    r = article.tags.collect do |t|
      t = t.name
      l = link_to t, group_tag_path(group, t), {:rel => 'tag'}
      l = content_tag :span, l, :class => 'current_tag' if current_tag and t.include? current_tag
      m[t]= l
      "(#{Regexp.escape(t)})"
    end
    reg = Regexp.new(r.join('|'))
    tag.gsub reg do |t|
      m[t]
    end
  end

  # TODO: optimize out the regexp match
  def rated? article
    logged_in? ? current_user.has_rated?(article) : AnonymousRating.has_rated?(request.remote_ip, article)
  end

  def format_content(article, group, watermark=false)
    prefix = group.name.mb_chars[0,2]
    
    # i don't know if ruby 1.9 support unicode regexp
    #r = Regexp.new "(#{prefix}＃|#{prefix}\#|\#|＃)(\\d+)"
    r = Regexp.new "(#{prefix}\#|\#)(\\d+)"
    
    content = h(article.content).
      gsub(/$/,"<br/>").
      gsub(/ /, '&nbsp;').
      gsub(r){ link_to "#{prefix}\#" + $2, article_path($2)}
    #content = add_watermark(content) if watermark
    content.html_safe
      #gsub(r){ "<a href=\"http://#{group.inherited(:domain)}/articles/#{$2}.htm\">#{prefix}\##{$2}</a>"}
  end


  WaterMark = ['(出品，转载请注明)', '[]', '(from zuikeai.net)', '(来自zuikeai.net)']
  Tags = ['span','div','b','strong']
  def add_watermark(content)
    array  = content.split(/<br\/>/)
    a = Tags[rand(Tags.length)]
    size = rand(array.length)
    array[size] = "#{array[size]}<#{a} class='watermark'>#{WaterMark[rand(WaterMark.size)]}</#{a}>"
    
    return array.join("<br/>")
  end
end
