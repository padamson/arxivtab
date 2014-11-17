class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :url
      t.integer :user_id

      t.timestamps
    end
    add_index :documents, [:user_id, :created_at]
  end
end
