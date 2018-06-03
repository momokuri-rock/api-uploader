class CreateUploadedFile < ActiveRecord::Migration[5.2]
  def change
    create_table :uploaded_files do |t|
      t.integer :user_id, null: false
      t.string :uuid, null: false
      t.string :name, null: false
      t.integer :size, null: false
      t.string :description
    end
  end
end
