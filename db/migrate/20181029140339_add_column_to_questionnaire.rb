class AddColumnToQuestionnaire < ActiveRecord::Migration[5.2]
  def change
    add_column :questionnaires, :uid, :string
  end
end
