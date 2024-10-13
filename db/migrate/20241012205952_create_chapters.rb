class CreateChapters < ActiveRecord::Migration[7.1]
  def change
    create_table :chapters do |t|
      t.integer :number
      t.string :title

      t.timestamps
    end
    add_index :chapters, :number, unique: true
    add_index :chapters, :title, unique: true
  end
end
