class AddUniqueIndexForContactOnUser < ActiveRecord::Migration[6.1]
  def change
    change_table :contacts do |t|
      t.string :email
      t.belongs_to :user, foreign_key: true
    end
    add_index :contacts, [:contact_list_id, :email], unique: true
    add_index :contacts, [:user_id, :email], unique: true
  end
end
