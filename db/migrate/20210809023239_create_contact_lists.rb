class CreateContactLists < ActiveRecord::Migration[6.1]
  def change
    create_table :contact_lists do |t|
      t.integer :status
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
