json.author do
  json.name @questionnaire.user_name
  json.email @questionnaire.user_email
  json.uuid @questionnaire.uid
end

json.collection_info do
    collection_info = @questionnaire.collection_info
    json.title collection_info&.title
    json.short_title collection_info&.short_title
    json.version collection_info&.version
    json.version_description collection_info&.version_description
    json.abstract collection_info&.abstract
    json.job_ids collection_info&.job_ids
end

json.contact do
  contact = @questionnaire.contact
  json.people do
    json.array!(contact&.people || []) do |person|
      json.first_name person.first_name
      json.middle_name person.middle_name
      json.last_name person.last_name
      json.email person.email
      json.role person.role
    end
  end
  json.organizations do
    json.array!(contact&.organizations || []) do |org|
      json.name org.name
      json.email org.email
      json.role org.role
    end
  end
end

json.project do
  project = @questionnaire.project
  json.agency project&.agency.present? ? project.agency : 'N/A'
  json.name project&.name.present? ? project.name : 'N/A'
  json.program project&.program.present? ? project.program : 'N/A'
end

json.dataset do
  dataset = @questionnaire.dataset
  json.title dataset&.title.present? ? dataset.title : 'N/A'
  json.version dataset&.version.present? ? dataset.version : 'N/A'
  json.version_description dataset&.version_description.present? ? dataset&.version_description : 'N/A'
  json.description dataset&.description.present? ? dataset.description : 'N/A'
  json.doi dataset&.doi.present? ? dataset.doi : 'N/A'
  json.nasa_processing_level dataset&.processing_level.present? ? dataset.processing_level : 'N/A'
  json.other_processing_level dataset&.other_processing_level.present? ? dataset.other_processing_level : 'N/A'
  json.constraints dataset&.constraints.present? ? dataset.constraints : 'N/A'
  json.public dataset&.public.present? ? dataset.public : 'N/A'
end

json.data_info do
  data_info = @questionnaire.data_info
  variables = data_info&.variables || []
  json.quality_assurance data_info&.quality_assurance.present? ? data_info.quality_assurance : 'N/A'
  json.format data_info&.format.present? ? data_info.format : 'N/A'
  json.size data_info&.data_size.present? ? data_info.data_size : 'N/A'
  json.compression_state data_info&.compression_state.present? ? data_info.compression_state : 'N/A'
  json.naming_convention_text data_info&.naming_convention_text.present? ? data_info.naming_convention_text : 'N/A'
end

json.temporal_extent do
  temporal_extent = @questionnaire.temporal_extent
  json.start_date temporal_extent&.start_date
  json.end_date temporal_extent&.end_date
  json.ongoing temporal_extent&.ongoing
end

json.spatial_extent do
  spatial_extent = @questionnaire.spatial_extent
  json.data_nature spatial_extent&.data_nature
  json.bounding_box_north spatial_extent&.bounding_box_north
  json.bounding_box_south spatial_extent&.bounding_box_south
  json.bounding_box_east spatial_extent&.bounding_box_east
  json.bounding_box_west spatial_extent&.bounding_box_west
end

json.keyword do
  keyword = @questionnaire.keyword
  json.science_keywords keyword&.science_keywords
  json.ancillary_keywords keyword&.ancillary_keywords
end

json.platforms do
  platforms = @questionnaire.platforms || []
  json.array!(platforms) do |platform|
    json.name platform.name
    json.instruments do
      json.array!(platform.instruments || []) do |instrument|
        json.name instrument.name
      end
    end
  end
end
json.related_info do
  related_info = @questionnaire.related_info
  json.published_paper_urls related_info&.published_paper_url
  json.user_documentation_urls related_info&.user_documentation_url
  json.algo_documentation_urls related_info&.algo_documentation_url
  json.algo_documentation_files related_info&.algo_documentation_urls
  json.user_documentation_files related_info&.user_documentation_urls
  json.published_paper_files related_info&.published_paper_urls
end
