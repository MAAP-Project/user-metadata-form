class CreateTemporalExtent < ActiveRecord::Migration[5.2]
  def change
    create_table :temporal_extents do |t|
      t.belongs_to :questionnaire
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :ongoing
      t.string :missing_explanation

      t.timestamps
    end
  end
end
