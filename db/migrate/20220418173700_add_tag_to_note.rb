class AddTagToNote < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :tag, :string
  end
end
