class CreatePages < ActiveRecord::Migration[7.1]
  def change
    create_table :pages do |t|
      t.references :chapter, null: false, foreign_key: true
      t.integer :order

      t.timestamps
    end
    add_index :pages, [:order, :chapter_id], unique: true
  end
end
