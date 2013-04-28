# -*- encoding : utf-8 -*-
module GroupsHelper
  
  def url_for_group group
    group = Group.find(group) unless group.is_a? Group
    if group.parent_id.nil?
      url_for('/', :host => group.domain)
    else
      url_for("/groups/#{group.id}", :host => group.inherited(:domain))
    end
  end

  def category_traverse(category, level = 0, s = [], &block)
    s << yield(category, level)
    level+=1
    for i in category.children
      category_traverse(i, level, s, &block)
    end
    s.join
  end
  
  def categories_options
    nested_set_options(Group) {|i| "#{'-' * i.level} #{i.name}" }
  end
end
