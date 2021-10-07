class CreateContactErrors < ActiveRecord::Migration[6.1]
  def change
    create_table :contact_errors do |t|
      t.jsonb :details
      t.belongs_to :contact_list, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :contact_errors, :details, using: :gin
  end
end
