class CumulusApi
  def self.create_cumulus_collection(collection_data)
    token = generate_token
    return HTTParty.post(
      collections_url,
      body: cumulus_collection(collection_data).to_json,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer #{token}"
      }
    )
  end

  def self.cumulus_collection(collection_data)
    return {
      version: '0',
      files: [
        {
          regex: '^(.*\\.\\w{1,})$', # make sure it has some suffix
          sampleFileName: 'test.xyz', 
          bucket: 'internal'
        }
      ],
      name: collection_data.title,
      sampleFileName: 'test.xyz',
      granuleIdExtraction: '^(.+)$',
      granuleId: '^.+$',
      dataType: collection_data.title,
      provider_path: '',
      userAdded: true,
      jobIds: collection_data.job_ids
    }
  end

  def self.generate_token
    response = Net::HTTP.post(
      URI(get_redirect_url),
      { credentials: auth_string }.to_json,
      { 'Content-Type': 'application/json', 'User-Agent': 'Net:HTTP', Origin: 'localhost'}
    )
    return JSON.parse(HTTParty.get(response['Location']).body)['message']['token']
  end

  def self.get_redirect_url
    response = HTTParty.get(authorize_url, follow_redirects: false)
    response.headers['location']
  end

  def self.authorize_url
    "#{PiQuestionnaire::Application::APP_CONFIG['cumulus_api']}/token"
  end

  def self.collections_url
    "#{PiQuestionnaire::Application::APP_CONFIG['cumulus_api']}/collections"
  end  

  def self.auth_string
    string = "#{ENV['EARTHDATA_USERNAME']}:#{ENV['EARTHDATA_PASSWORD']}"
    Base64.encode64(string).gsub("\n", '')
  end
end