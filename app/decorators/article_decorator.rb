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
end
