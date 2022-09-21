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
            path: "aimeeb"
        })
    end
    
    test "should create a valid provider object" do
        provider = CumulusApi.cumulus_provider(test_collection_info)
        assert_equal(provider[:host], 'maap-dit-workspace')
        assert_equal(provider[:id], 'maap-dit-workspace')
        assert_equal(provider[:protocol], 's3')
    end

    test 'should create a valid collection object' do
        collection = CumulusApi.cumulus_collection(test_collection_info)
        assert_equal(collection[:meta][:provider_path], 'aimeeb')
        assert_equal(collection[:files][0][:regex], nil)
        assert_equal(collection[:name], 'local_testing')
        assert_equal(collection[:granuleIdExtraction], nil)

    end
end