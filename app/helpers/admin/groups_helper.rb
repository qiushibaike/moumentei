# -*- encoding : utf-8 -*-
module Admin::GroupsHelper
  def options_check_box obj, field, label
    checked = "checked='check'" if @group.options[field.to_sym]
    raw <<html
    <input type="hidden" name="group[options][#{field}]" value="no" />
    <label class='checkbox'><input type="checkbox" name="group[options][#{field}]" value="yes" #{checked} />
    #{label}</label>
html
  end

end
