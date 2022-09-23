require 'test_helper'
require 'collection_info'

class CumulusApiTest < ActiveSupport::TestCase
    def collection_shortname
       return 'local_testing_1A'
    end
    def test_collection_info
        return CollectionInfo.create({
            title: "Local Testing 1A",
            short_title: collection_shortname,
            version: "001",
            version_description: "",
            abstract: "N/A",
            bucket: "maap-dit-workspace",
            path: "aimeeb",
            filename_prefix: collection_shortname
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
        assert_equal(collection[:name], collection_shortname)
        assert_equal(collection[:files][0][:regex], "^(local_testing_1A.+)\\..+")
        assert_equal(collection[:granuleIdExtraction], "^(local_testing_1A.+)\\..+")
        assert_equal(collection[:granuleId], "^local_testing_1A[^.]+$")
        meta = {
            userAdded: true,
            provider: 'maap-dit-workspace',
            provider_path: 'aimeeb',
            workflow_steps: {
                sync: nil
            }
        }
        assert_equal(collection[:meta], meta)
    end

    test 'file_regex produced from shortname should match the file in any file path and extract the right granule ID' do
        filename = "#{collection_shortname}_foo_bar.baz"
        regex_str = CumulusApi.file_regex(collection_shortname)
        regex = Regexp.new(regex_str)
        matches = filename.match(regex)
        assert_equal(matches[1], "#{collection_shortname}_foo_bar")
    end

    test 'if file prefix is none, will still return a regex' do
        filename = "foo_bar.baz"
        regex_str = CumulusApi.file_regex(nil)
        regex = Regexp.new(regex_str)
        matches = filename.match(regex)
        assert_equal(matches[1], "foo_bar")
    end        
end