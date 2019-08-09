class ApiCredential < ApplicationRecord
  validates_presence_of :api_key

  before_create :generate_key

  private
    def generate_key
      print("API key: #{SecureRandom.hex}")
      self.api_key = Digest::SHA256.hexdigest(SecureRandom.hex)
    end
end