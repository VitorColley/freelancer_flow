class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.decimal :budget
      t.string :status
      t.references :client, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
