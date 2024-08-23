class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :api_key

      t.timestamps
    end
    # Add an index to ensure email uniqueness
    add_index :users, :email, unique: true
    # Add an index for API key lookup
    add_index :users, :api_key, unique: true
  end
end
