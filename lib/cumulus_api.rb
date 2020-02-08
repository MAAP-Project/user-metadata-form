class CumulusApi
  def self.create_cumulus_collection(collection_data)
    token = generate_token
    headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer #{token}"
    }
    body = cumulus_collection(collection_data).to_json
    response = HTTParty.put(
      "#{collections_url}/#{collection_data.short_title}/#{collection_data.version}",
      body: body,
      headers: headers
    )
    if response.code === 404
      response = HTTParty.post(
        collections_url,
        body: body,
        headers: headers
      )
    end
    response
  end

  def self.cumulus_collection(collection_data)
    return {
      version: collection_data.version,
      files: [
        {
          regex: '^(.*\\.\\w{1,})$', # make sure it has some suffix
          sampleFileName: 'test.xyz', 
          bucket: 'internal'
        }
      ],
      name: collection_data.short_title,
      sampleFileName: 'test.xyz',
      granuleIdExtraction: '^(.+)$',
      granuleId: '^.+$',
      dataType: collection_data.short_title,
      meta: {
        userAdded: true,
        jobIds: collection_data.job_ids,
        uploadDirectories: collection_data.upload_directories
      }
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
