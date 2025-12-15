class CreatePortfolioItems < ActiveRecord::Migration[8.1]
  def change
    create_table :portfolio_items do |t|
      t.references :freelancer, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :url

      t.timestamps
    end
  end
end
