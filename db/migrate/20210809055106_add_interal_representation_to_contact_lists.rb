class AddInteralRepresentationToContactLists < ActiveRecord::Migration[6.1]
  def change
    add_column :contact_lists, :ir, :jsonb
  end
end
