class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name, index: true
      t.string :last_name, index: true
      t.string :email, index: true
      t.string :password_digest
      t.timestamps
    end
  end
end
