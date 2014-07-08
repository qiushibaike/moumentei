class ArticleDecorator < Draper::Decorator
  delegate_all
  decorates_association :comments, with: PaginatingDecorator

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def title_link
    h.link_to object.title, [article.group, article], title: object.title, rel: 'bookmark'
  end

  def author_name
    if object.user.present?
      if object.anonymous
        "Anonymous"
      else
        object.user.login
      end
    else
      "Guest"
    end
  end

  def comment_count_status
    if object.comment_status == 'closed'
      '禁止评论'
    else
      object.public_comments_count > 0 ? "#{object.public_comments_count}条评论" : "暂无评论"
    end
  end

  def published_date(prefix="发表于")
    h.concat prefix
    h.link_to h.archive_path(object.group, :date => object.created_at) do
      h.content_tag :abbr, object.created_at.strftime("%Y-%m-%d"), class: "published", title: object.created_at.iso8601
    end
  end

  def ip
    IPUtils.long2ip(object.ip)
  end

  def url
    h.url_for([object.group, object])
  end

  def content
    h.auto_link object.content
  end

  def thumb_picture

    if object.picture.file?
      if object.picture.content_type =~ /gif/i
          h.image_tag(object.picture(:original), alt: (object.title || object.content[0, 10]))
      else
          h.link_to h.image_tag(object.picture(:medium), alt: (object.title || object.content[0, 10])),
                    object.picture(:original),
                    class: 'picture', id: "picture-#{id}", title: (object.title || object.content[0, 10])
      end
    end
  end
end
