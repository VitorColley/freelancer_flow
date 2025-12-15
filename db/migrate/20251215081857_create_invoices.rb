class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices do |t|
      t.references :project, null: false, foreign_key: true
      t.decimal :amount
      t.string :status
      t.datetime :issued_at

      t.timestamps
    end
  end
end
