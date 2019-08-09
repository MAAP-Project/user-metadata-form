class NotificationMailer < ApplicationMailer

  EMAIL_LIST = ['jeanne.leroux@nsstc.uah.edu', 'kaylin.m.bugbee@nasa.gov']

  def questionnaire_filled(options={})
    @questionnaire = Questionnaire.where(uid: options[:uuid]).last
    mail(to: EMAIL_LIST, subject: 'Questionnaire Received')
  end

  def questionnaire_updated(options={})
    @questionnaire = Questionnaire.where(uid: options[:uuid]).last
    mail(to: EMAIL_LIST, subject: 'Questionnaire Updated')
  end
end
