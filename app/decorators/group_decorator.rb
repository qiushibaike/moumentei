class GroupDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  def day_link
    h.link_to_unless_current('24小时内热评', {action: :most_replied, id: object.id, limit: 'day'})
  end
  def week_link
    h.link_to_unless_current '1周内', action: :most_replied, id: object.id, limit: 'week'
  end

  def month_link
    h.link_to_unless_current '1月内', action: :most_replied, id: object.id, limit: 'month'
  end

  def year_link
    h.link_to_unless_current '1年内', action: :most_replied, id: object.id, limit: 'year'
  end

  def all_link
    h.link_to_unless_current '有史以来', action: :most_replied, id: object.id, limit: 'all'
  end
end
