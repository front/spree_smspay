class CreateSpreeSmspayMobileNumbers < ActiveRecord::Migration
  def change
    create_table :spree_smspay_mobile_numbers do |t|
      t.references :user, index: true
      t.references :payment_method, index: true
      t.boolean :default, default: false
      t.string :code
      t.string :number
      t.timestamps
    end
  end
end
