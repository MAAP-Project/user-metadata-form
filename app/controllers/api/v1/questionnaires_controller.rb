class Api::V1::QuestionnairesController < Api::V1::BaseController
  # before_action :authenticate_request

  def index
    @questionnaires = Questionnaire.where(finished: true)
  end

  def show
    @questionnaire = Questionnaire.where(uid: params[:id]).last
    if @questionnaire.nil?
      head '404'
    end
  end

  # Public: Create the questionnaire via API.
  #
  #
  # {
  #   questionnaire: { user_name: 'name', user_email: 'email', {
  #   platforms_attributes: [ {
  #     name: 'platform name',
  #     instruments_attributes: [{
  #       name: 'instrument name'
  #     }]
  #   },
  #   collection_info: {
  #     title: 'title',
  #     short_title: 'short title',
  #     version: 'version number',
  #     version_description: 'explanation of version',
  #     abstract: 'abstract',
  #     status: 'status'
  #   },
  #   contact: {
  #     people_attributes: [{
  #       first_name: 'first name',
  #       middle_name: 'middle name',
  #       last_name: 'last name',
  #       email: 'email',
  #       role: 'role'
  #     }],
  #     organizations_attributes: [{
  #       name: 'org name',
  #       email: 'email',
  #       role: 'role'
  #     }]
  #   },
  #   temporal_extent: {
  #     missing_explanation: 'explaination for missing data',
  #     end_date: 'end date yyyy-mm-dd',
  #     start_date: 'start date yyyy-mm-dd',
  #     ongoing: 'boolean (true or false)'
  #   },
  #   spatial_extent: {
  #     spatial_nature: 'nature of the data',
  #     bounding_box_north: 'northern coordinate of bb',
  #     bounding_box_south: 'southern coordinate of bb',
  #     bounding_box_east: 'eastern coordinate of bb',
  #     bounding_box_west: 'western coordinate of bb',
  #   },
  #   dataset: {
  #     title: 'title',
  #     version: 'version',
  #     version_description: 'explaination of version',
  #     description: 'general description',
  #     doi: 'DOI',
  #     processing_level: 'processing level',
  #     constraints: 'constraints on the data',
  #     public: 'is the data public or are there some restrictions to it'
  #   },
  #   data_info: {
  #     quality_assurance: 'quality assurance',
  #     constraints: 'constraints',
  #     format: 'format of data',
  #     size: 'size of data',
  #     size_format: 'format of data',
  #     compression_state: 'what is the state of the data? (compressed or uncompressed or mixed) ?',
  #     naming_convention_text: 'Naming convention of the data files.',
  #     naming_convention: [ "FILEUPLOADS (accepts multiple files)." ]
  #   },
  #   related_info: {
  #     published_paper_url: 'url of the published paper',
  #     user_documentation_url: 'url to the documentation',
  #     algo_documentation_url: 'url to the algorithm',
  #     additional_info: 'any additional info',
  #     browse_imagery: 'Does the data have browse images?',
  #     algo_documentation: ["FILEUPLOADS (accepts multiple files)."],
  #     user_documentation: ["FILEUPLOADS (accepts multiple files)."],
  #     published_paper: ["FILEUPLOADS (accepts multiple files)."]
  #   },
  #   keyword: {
  #     science_keywords: 'keywords',
  #     ancillary_keywords: 'keywords'
  #  },
  #   platform: {
  #     agency: 'agency name',
  #     name: 'name of the platform',
  #     program: 'Program name'
  #   }
  #  }
  #
  def create
    (PartialHandler::FLOW - ['platforms']).each do |partial|
      if params[partial]
        partial_handler = PartialHandler.new(params[partial])
        partial_handler.create
        @questionnaire, @current_resource, _ = partial_handler.load_next_resources
        valid = current_resource.valid?
        errors = { errors: current_resource.errors.messages }
        render json: errors unless valid
      else
        render json: { errors: "#{partial} key is required." }
      end
    end
    @questionnaire.update_attribute(:finished, true)
    render json: @questionnaire
  end

  def destroy
  end

  private
    def authenticate_request
      api_key = Digest::SHA256.hexdigest(request.headers['X-Api-Key'] || '')
      unless ApiCredential.where(api_key: api_key).last
        head :forbidden
        return false
      end
    end
end
