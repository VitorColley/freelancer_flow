class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.references :project, null: false, foreign_key: true
      t.references :reviewer, null: false, foreign_key: true
      t.references :reviewee, null: false, foreign_key: true
      t.integer :rating
      t.text :comment

      t.timestamps
    end
  end
end
