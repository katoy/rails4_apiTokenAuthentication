class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :age
      t.string :email

      t.string :access_token
      t.datetime :token_created_at

      t.timestamps null: false
    end
    add_index :products, [:access_token, :token_created_at]
  end
end
