class CreateTokenData < ActiveRecord::Migration
  def change
    create_table :token_data do |t|
      t.string :access_token
      t.string :refresh_token
      t.integer :expires_in
      t.string :scope
      t.string :account_id

      t.timestamps null: false
    end
  end
end
