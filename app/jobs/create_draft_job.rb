class CreateDraftJob < ApplicationJob
  queue_as :default

  def perform(questionnaire)
    view = ActionView::Base.new(
        'app/views/api/v1/questionnaires',
        {},
        ActionController::Base.new
      )

    questionnaire = Questionnaire.where(id: questionnaire['id']).last
    # Create the Cumulus collection
    collection_info = questionnaire.collection_info
    response = CumulusApi.create_cumulus_collection(collection_info)
    Rails.logger.info "Created Cumulus collection #{response}"

    output = view.render(
        file: '_questionnaire_details.json.jbuilder',
        locals: { questionnaire: questionnaire }
      )
    HTTParty.post(
        PiQuestionnaire::Application::APP_CONFIG['mmt_url'],
        body: output,
        headers: { 'Content-Type': 'application/json' }
      )

    NotificationMailer.questionnaire_filled(
      uuid: questionnaire.uid
    ).deliver_now
  end
end
