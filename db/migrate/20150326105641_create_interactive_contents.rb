class CreateInteractiveContents < ActiveRecord::Migration
  def change
    create_table :interactive_contents do |t|
      t.string :content_type
      t.string :name
      t.date :production_date
      t.string :producer_name
      t.string :admin_note

      t.timestamps
    end
  end
end
