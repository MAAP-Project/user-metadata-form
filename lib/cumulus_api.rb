class CumulusApi
  def self.create_cumulus_provider(collection_data)
    token = generate_token
    headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer #{token}"
    }
    body = cumulus_provider(collection_data).to_json
    response = HTTParty.put(
      "#{providers_url}/#{collection_data.bucket}",
      body: body,
      headers: headers
    )
    if response.code === 404
      response = HTTParty.post(
        providers_url,
        body: body,
        headers: headers
      )
    end
    response
  end

  def self.cumulus_provider(collection_data)
    return {
      host: collection_data.bucket,
      id: collection_data.bucket,
      protocol: 's3'
    }
  end

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
          bucket: 'internal',
          type: 'data'
        }
      ],
      name: collection_data.short_title,
      sampleFileName: 'test.xyz',
      granuleIdExtraction: '^(.+)$',
      granuleId: '^.+$',
      dataType: collection_data.short_title,
      duplicateHandling: 'replace',
      meta: {
        userAdded: true,
        provider_path: collection_data.upload_directories[0],
        provider: collection_data.bucket,
        workflow_steps: {
          sync: nil
        }
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
    "#{ENV['CUMULUS_REST_API']}/token"
  end

  def self.collections_url
    "#{ENV['CUMULUS_REST_API']}/collections"
  end

  def self.providers_url
    "#{ENV['CUMULUS_REST_API']}/providers"
  end

  def self.auth_string
    string = "#{ENV['EARTHDATA_USERNAME']}:#{ENV['EARTHDATA_PASSWORD']}"
    Base64.encode64(string).gsub("\n", '')
  end
end
