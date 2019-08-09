class CreateDraftJob < ApplicationJob
  queue_as :default

  def perform(questionnaire)
    view = ActionView::Base.new(
        'app/views/api/v1/questionnaires',
        {},
        ActionController::Base.new
      )
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
