class AddDetailsToSubject < ActiveRecord::Migration
  def change
    add_column :subjects, :board, :string
    add_column :subjects, :standard, :integer
  end
end
