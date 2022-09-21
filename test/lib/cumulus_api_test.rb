require 'test_helper'
require 'collection_info'

class CumulusApiTest < ActiveSupport::TestCase
    def test_collection_info
        return CollectionInfo.create({
            title: "Local Testing",
            short_title: "local_testing",
            version: "001",
            version_description: "",
            abstract: "N/A",
            bucket: "maap-dit-workspace",
            prefix: "aimeeb"
        })
    end
    
    test "should create a valid provider object" do
        provider = CumulusApi.cumulus_provider(test_collection_info)
        assert_equal(provider[:host], 'maap-dit-workspace')
    end
end