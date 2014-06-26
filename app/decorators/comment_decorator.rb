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

  def url
    h.url_for object.article
  end
end
