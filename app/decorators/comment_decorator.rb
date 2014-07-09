class CommentDecorator < Draper::Decorator
  decorates_association :article
  delegate_all

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

  def author_path
    if object.user.present?
      h.user_path object.user
    else
      '#'
    end
  end

  def created_date(class_names="comment-date", **attributes)
    h.content_tag :abbr, comment.created_at.strftime("%Y-%m-%d %H:%M:%S"), title: '', class: class_names
  end

  def ip
    IPUtils.long2ip(object.ip)
  end
end
