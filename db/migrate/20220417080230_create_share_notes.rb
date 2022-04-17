class CreateShareNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :share_notes do |t|
      t.integer :user_id
      t.integer :note_id
      t.integer :parent_id

      t.timestamps
    end
  end
end
