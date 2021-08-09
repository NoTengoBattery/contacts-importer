class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.jsonb :details
      t.belongs_to :contact_list, null: false, foreign_key: true

      t.timestamps
    end

    add_index :contacts, :details, using: :gin
  end
end
