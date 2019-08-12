class PartialHandler
  FLOW = [
           'questionnaire', 'collection_info', 'data_info', 'related_info', 'keyword', 'temporal_extent', 'spatial_extent'
         ]
  PARTIAL_FORMAT = "%s_form"
  attr_accessor :params, :current_partial, :current_index, :camelized_partial,
                :current_model, :questionnaire, :update_params,
                :created_resource


  def initialize(params)
    @params = params
    @current_partial = params['current_partial']
    @current_partial = 'questionnaire' if current_partial == 'platforms'
    @camelized_partial = current_partial.camelize.singularize
    current_resource
    @current_index = FLOW.index(params['current_partial'])
    @update_params = "#{camelized_partial}::PERMITTED_PARAMS".constantize
  end

  def next_partial
    FLOW[current_index + 1]
  end

  def previous_partial
    FLOW[current_index - 1]
  end

  def find_current(partial=nil)
    id = params[:id] || params[:questionnaire_id]
    questionnaire = Questionnaire.where(id: id).last
    questionnaire ||= Questionnaire.where(uid: params[:questionnaire_uuid]).last
    partial ||= current_partial
    resource = questionnaire.send(current_partial)
    [questionnaire, resource, PARTIAL_FORMAT % partial]
  end

  def permitted_params
    params.require(current_partial).permit(update_params)
  end

  def create
    @created_resource = current_model.create(
      permitted_params
    )
  end

  def update
    questionnaire, @created_resource, partial = find_current
    created_resource.update_attributes(permitted_params)
    # for update
  end

  def current_resource
    @current_model ||= load_resource
  end

  def load_resource(model_name = camelized_partial)
    model_name.constantize
  end

  def load_next_resources
    questionnaire = created_resource.questionnaire
    if next_partial.present?
      if not((next_resource = questionnaire.send(next_partial)).present?)
        next_resource = load_resource(next_partial.singularize.camelize).new
        next_resource = next_resource.build_resources(questionnaire)
      elsif next_partial == 'platforms'
        next_resource = questionnaire
      end
      partial = PARTIAL_FORMAT % next_partial
    end
    [questionnaire, next_resource, partial]
  end
end
