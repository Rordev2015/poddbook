class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
    add_column :users, :city, :string
    add_column :users, :gender, :string
  end
end
