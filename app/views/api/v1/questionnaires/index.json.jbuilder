json.array!(@questionnaires) do |questionnaire|
  json.partial! 'questionnaire_details', questionnaire: questionnaire
end