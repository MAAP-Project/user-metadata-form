# :nodoc:
module ControlledKeywords
  extend ActiveSupport::Concern

  def get_controlled_keyword_short_names(keywords)
    keywords.map do |keyword|
      values = []
      keyword.fetch('subfields', []).each do |subfield|
        values += if subfield == 'short_name'
                    keyword.fetch('short_name', []).map do |short_name|
                      url = short_name.fetch('url', [{}]).first['value'] || short_name.fetch('long_name', [{}]).first.fetch('url', [{}]).first['value']

                      {
                        short_name: short_name['value'],
                        long_name: short_name.fetch('long_name', [{}]).first['value'],
                        url: url
                      }
                    end
                  else
                    get_controlled_keyword_short_names(keyword.fetch(subfield, []))
                  end
      end
      values.flatten
    end
  end

  def fetch_science_keywords
    response = HTTParty.get('https://cmr.earthdata.nasa.gov/search/keywords/science_keywords')
    if response.code == 200
      JSON.parse(response.body)
    else
      []
    end
  end
end