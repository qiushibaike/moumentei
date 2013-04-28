# -*- encoding : utf-8 -*-
class BootstrapLinkRenderer < WillPaginate::ActionView::LinkRenderer
  def initialize
    @gap_marker = '<span class="gap">&hellip;</span>'
  end

  def to_html
    links = @options[:page_links] ? windowed_links : []
    # previous/next buttons
    page = @collection.previous_page
    links.unshift(
        page_link(page, @options[:previous_label], :class => 'prev_page'))
    page = @collection.next_page
    links.push(
        page_link(page, @options[:next_label], :class => 'next_page'))
    html = links.join(@options[:separator])
    @options[:container] ? @template.content_tag(:div, @template.content_tag(:ul, html), html_attributes) : html
  end
  def gap
    tag :li, link(super, '#'), :class => 'disabled'
  end
  def html_container(html)
    tag :div, tag(:ul, html), container_attributes
  end
  protected
    def windowed_links
      visible_page_numbers.map { |n| page_link_or_span(n, (n == current_page ? 'current' : nil)) }
    end

    def page_link_or_span(page, span_class, text = nil)
      text ||= page.to_s
      if page && page != current_page
        page_link(page, text, :class => span_class)
      else
        page_link(page, text, :class => "#{span_class} active")
      end
    end

    def page_link(page, text, attributes = {})
      @template.content_tag(:li, @template.link_to(text, url_for(page)), attributes)
    end

    def page_span(page, text, attributes = {})
      @template.content_tag(:li, text, attributes)
    end
  end
