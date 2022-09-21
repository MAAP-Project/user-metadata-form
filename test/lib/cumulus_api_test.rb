require 'test_helper'
require 'collection_info'

class CumulusApiTest < ActiveSupport::TestCase
    def test_collection_info
        return CollectionInfo.create({
            id: 1,
            questionnaire_id: 1,
            title: "Local Testing",
            short_title: "local_testing",
            version: "001",
            version_description: "",
            abstract: "N/A",
            status: nil,
            created_at: 'Tue, 20 Sep 2022 20:02:21 UTC +00:00',
            updated_at: 'Tue, 20 Sep 2022 20:02:21 UTC +00:00',
            bucket: "maap-dit-workspace",
            upload_directories: ["aimeeb/my-data-bucket/"]            
        })
    end
    
    test "should create a valid provider object" do
        provider = CumulusApi.cumulus_provider(test_collection_info)
        assert_equal(provider[:host], 'maap-dit-workspace')
    end
end