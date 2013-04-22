# -*- encoding : utf-8 -*-
module Admin::ArticlesHelper
  #Public bootstrap风格的日期选择
  #
  #Example -
  # =>  <% datepicker_for do%>
  #     <%= text_field_tag 'begin', @start_date, :readonly => true%>
  #     <%end%>
  #
  def datepicker_for(&block)
    tmp = with_output_buffer(&block)
    concat(%{<div class="input-append date datepicker">#{tmp}<span class="add-on"><i class="icon-th"></i></span></div>}.html_safe)
  end

  def datetimepicker_for(name, value = nil, options = {})
    date = (value || Time.now.to_s(:db)).split(" ")[0]
    time = (value || Time.now.to_s(:db)).split(" ")[1]
    value = "#{date} #{time}".html_safe
%{<div class="input-append datetimepicker">
<input type="text" value="#{date}" class="datepicker input-small" >
<input type="text" value="#{time}" class="timepicker input-small">
#{hidden_field_tag(name,value)}
</div>}.html_safe
  end  
end
