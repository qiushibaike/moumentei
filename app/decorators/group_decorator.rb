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
  def day_link(page=nil, options={})
    h.link_to_unless_current('24小时内热评', {action: :index, controller: :articles, group_id: object.id, hottest_by: 'day', page: page}, options)
  end
  def week_link(page=nil)
    h.link_to_unless_current '1周内', {action: :index, controller: :articles, group_id: object.id, hottest_by: 'week', page: page}
  end

  def month_link(page=nil)
    h.link_to_unless_current '1月内', {action: :index, controller: :articles, group_id: object.id, hottest_by: 'month', page: page}
  end

  def year_link(page=nil)
    h.link_to_unless_current '1年内', {action: :index, controller: :articles, group_id: object.id, hottest_by: 'year', page: page}
  end

  def all_link(page=nil)
    h.link_to_unless_current '有史以来', {action: :index, controller: :articles, group_id: object.id, hottest_by: 'all', page: page}
  end

  def recent_hot_link(content="最近热点", page=nil, options={})
    # h.link_to content, {action: :index, group_id: object.id, controller: :articles, recent_hot: true, page: page}, options
    h.link_to content, h.recent_hot_group_articles_path(object, page), options
  end
end
