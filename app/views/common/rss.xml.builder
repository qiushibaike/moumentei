xml.instruct!
xml.instruct!('xml-stylesheet', :type => "text/xsl", :href =>"/stylesheets/rsspretty.xsl")

@items ||= @options[:items]
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/", "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    @options[:pubDate] = @items.any? ? @items.first[:pubDate] : Time.now if not @options.include?(:pubDate)
    xml.atom :link, :href => "http://#{request.domain}#{request.request_uri}", :rel => 'self', :type => 'application/rss+xml' 
    xml.title       @options[:title] || ''
    xml.link        @options[:link]  || home_url
    xml.pubDate     @options[:pubDate].is_a?(String) ? @options[:pubDate] : @options[:pubDate].rfc2822
    xml.description @options[:description]  || ''

    @options[:items].each do |item|
      xml.item do
        des = item[:description]
        xml.title       item[:title]
        xml.link        item[:link]
        xml.description des.is_a?(Array) ? render(:partial => des[0], :object => des[1]) : des
        xml.pubDate     item[:pubDate].is_a?(String) ? item[:pubDate] : item[:pubDate].rfc2822
        xml.guid        item[:guid] || "#{item[:link]};#{Time.now}"
        xml.author      item[:author]
      end
    end
  end
end
