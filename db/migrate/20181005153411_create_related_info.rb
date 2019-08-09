class CreateRelatedInfo < ActiveRecord::Migration[5.2]
  def change
    create_table :related_infos do |t|
      t.belongs_to :questionnaire, index: true
      t.string :published_paper_url
      t.string :user_documentation_url
      t.string :algo_documentation_url

      t.string :published_paper, array: true, default: []
      t.string :user_documentation, array: true, default: []
      t.string :algo_documentation, array: true, default: []
      t.boolean :browse_imagery
      t.string :additional_info

      t.timestamps
    end
  end
end
