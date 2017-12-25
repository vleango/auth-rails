class CreateUserTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :user_tokens do |t|
      t.references :user, required: true, index: true
      t.string :access
      t.string :token, index: :true
      t.timestamps
    end
  end
end
