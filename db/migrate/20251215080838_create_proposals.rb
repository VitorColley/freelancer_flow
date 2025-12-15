class CreateProposals < ActiveRecord::Migration[8.1]
  def change
    create_table :proposals do |t|
      t.references :project, null: false, foreign_key: true
      t.references :freelancer, null: false, foreign_key: true
      t.text :message
      t.decimal :bid_amount
      t.string :status

      t.timestamps
    end
  end
end
