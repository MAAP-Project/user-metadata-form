class CreateApiCredential < ActiveRecord::Migration[5.2]
  def change
    create_table :api_credentials do |t|
      t.string :api_key
    end
  end
end
