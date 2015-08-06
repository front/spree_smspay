class CreateSpreeSmspayCheckouts < ActiveRecord::Migration
  def change
    create_table :spree_smspay_checkouts do |t|
      t.integer :reference
      t.decimal :amount
      t.string :status
      t.references :order, index: true
      t.references :smspay_mobile_number, index: true
      t.timestamps
    end
  end
end
