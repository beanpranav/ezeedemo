class AddPaymentToUser < ActiveRecord::Migration
  def change
    add_column :users, :term_1_payment, :integer, default: 0
    add_column :users, :term_2_payment, :integer, default: 0
  end
end
