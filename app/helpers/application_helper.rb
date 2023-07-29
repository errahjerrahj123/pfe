module ApplicationHelper
  
   def observe_select_field(field_id, select_options, html_options = {})
    select_tag(field_id, options_for_select(select_options), html_options)
  end
  


  private
  def observe_field_js(field_id,  url , options = {})
    onchange = options.delete(:onchange)
    before = options.delete(:before)
    success = options.delete(:success)

    js = "$('##{field_id}').on('change', function() {"
    js += "#{before};" if before.present?
    js += "$.ajax({"
    js += "url: '#{url}',"
    js += "type: 'POST',"
    js += "dataType: 'script',"
    js += "data: { role: $(this).val() },"
    js += "success: function() { #{success}; }" if success.present?
    js += "});"
    js += "#{onchange};" if onchange.present?
    js += "});"
    js.html_safe
  end

 
end

