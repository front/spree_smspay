class CreateSmspayCheckouts < ActiveRecord::Migration
  def change
    create_table :smspay_checkouts do |t|
      t.integer :reference
      t.decimal :amount
      t.string :status
      t.references :order, index: true
      t.timestamps
    end
  end
end
