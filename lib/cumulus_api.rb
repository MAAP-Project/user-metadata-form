class CumulusApi
  def self.create_cumulus_resource(resource, collection_data)
    token = generate_token
    headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer #{token}"
    }
    case resource
    when 'provider'
      body = cumulus_provider(collection_data).to_json
      cumulus_put_endpoint = "#{providers_url}/#{collection_data.bucket}"
      cumulus_post_endpoint = providers_url
    when 'collection'
      body = cumulus_collection(collection_data).to_json
      cumulus_put_endpoint = "#{collections_url}/#{collection_data.short_title}/#{collection_data.version}"
      cumulus_post_endpoint = collections_url
    else
      throw 'Resource type not supported'
    end
    response = HTTParty.put(
      cumulus_put_endpoint,
      body: body,
      headers: headers
    )
    if response.code === 404
      response = HTTParty.post(
        cumulus_post_endpoint,
        body: body,
        headers: headers
      )
    end
    response
  end

  def self.create_cumulus_provider(collection_data)
    self.create_cumulus_resource('provider', collection_data)
  end

  def self.create_cumulus_collection(collection_data)
    self.create_cumulus_resource('collection', collection_data)
  end

  def self.cumulus_provider(collection_data)
    return {
      host: collection_data.bucket,
      id: collection_data.bucket,
      protocol: 's3'
    }
  end

  def self.cumulus_collection(collection_data)
    if collection_data.filename_regex != nil
      regex = collection_data.filename_regex
      # Not sure what this should be
      granuleIdExtraction = "^(#{collection_data.filename_regex}.+)$"
    elsif collection_data.filename_prefix != nil
      regex = "^.+#{collection_data.filename_prefix}(.*\\.\\w{1,})$",
      granuleIdExtraction = "^(#{collection_data.filename_prefix}.+)$"     
    end
  
    return {
      version: collection_data.version,
      files: [
        {
          regex: regex, # make sure it has some suffix
          sampleFileName: 'test.xyz',
          bucket: 'internal',
          type: 'data'
        }
      ],
      name: collection_data.short_title,
      sampleFileName: 'test.xyz',
      granuleIdExtraction: granuleIdExtraction,
      granuleId: '^.+$',
      dataType: collection_data.short_title,
      duplicateHandling: 'replace',
      meta: {
        userAdded: true,
        provider_path: collection_data.path,
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
