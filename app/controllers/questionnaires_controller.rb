class QuestionnairesController < ApplicationController
  http_basic_authenticate_with name: ENV['USER_NAME'],
    password: ENV['VIEW_PASSWORD'], except: [:create, :update, :new, :files]

  def index
    @questionnaires = Questionnaire.all
  end

  def show
    @questionnaire = Questionnaire.where(uid: params[:id]).last
    if @questionnaire.nil?
      head '400'
    end
    respond_to :json
  end

  def new
    @questionnaire = Questionnaire.where(uid: params['questionnaire_uuid']).last
    @questionnaire ||= Questionnaire.new
    @current_resource = @questionnaire
    @partial = 'questionnaire_form'
    @previous_partial = nil
    @hide_form = params['questionnaire_uuid']
    if request.xhr? || @hide_form
      params['current_partial'] = params['previous_partial'] || 'questionnaire'
      partial_handler = PartialHandler.new(params)
      @previous_partial = partial_handler.previous_partial
      @questionnaire, @current_resource, @partial = partial_handler.find_current(
          params['current_partial']
        )
      render :create if request.xhr?
    end
  end

  def create
    partial_handler = PartialHandler.new(params)
    partial_handler.create
    @previous_partial = params['current_partial']
    @questionnaire, @current_resource, @partial = partial_handler.load_next_resources
    handle_completed
  end

  def update
    partial_handler = PartialHandler.new(params)
    partial_handler.update
    @previous_partial = params['current_partial']
    @questionnaire, @current_resource, @partial = partial_handler.load_next_resources
    handle_completed
  end

  def clone
    questionnaire = Questionnaire.where(uuid: params[:uuid]).last
    @copy_questionnaire = questionnaire.dup
    @copy_questionnaire.uid = SecureRandom.uuid
    @copy_questionnaire.save
    relations = @copy_questionnaire.reflections.select do |association_name, reflection|
      reflection.macro == :has_many || reflection.macro == :has_one
    end.keys
    relations.each do |rel|
      @copy_questionnaire.send("#{rel}=", questionnaire.send(relations).dup)
      @copy_questionnaire.send("#{rel}").save
    end
  end

  def destroy
  end

  def files
    @questionnaire = Questionnaire.find(params[:id])
    @partial = "#{params[:current_partial]}_form"
    @current_resource = @questionnaire.send(params[:current_partial])
    if params[:current_partial] == 'data_info'
      @current_resource.remove_naming_convention!
    else
      documents = @current_resource.send(params['document'])
      current_doc_ind = nil
      documents.each.with_index do |doc, ind|
        if doc.file.filename == params['file_name']
          current_doc_ind = ind
        end
      end
      @current_resource.send(params['document'])[current_doc_ind]&.remove!
      @current_resource[params['document']].delete_at(current_doc_ind)
    end
    if @current_resource.save
      @questionnaire.reload
      @current_resource.reload
      render :create
    else
      head :unprocessable_entity
    end
  end

  private
    def handle_completed
      if @partial.blank?
        @questionnaire.update_attribute(:finished, true)
        flash[:notice] = 'Questionnaire response received!'
        CreateDraftJob.perform_later(@questionnaire)
        redirect_to root_path
      else
        render :create
      end
    end
end
