module ViewHelper
  def form_path(questionnaire, current_resource, current_partial)
    if current_resource.new_record?
      http_verb = :post
      path = questionnaires_path(current_partial: current_partial)
    else
      http_verb = :put
      path = questionnaire_path(questionnaire, current_partial: current_partial)
    end
    [http_verb, path]
  end

  def flash_class(level)
    case level
      when 'notice' then 'alert alert-info'
      when 'success' then 'alert alert-success'
      when 'error' then 'alert alert-error'
      when 'alert' then 'alert alert-error'
    end
  end
end