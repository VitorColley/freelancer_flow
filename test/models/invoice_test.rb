require "test_helper"

class InvoiceTest < ActiveSupport::TestCase

  test "valid invoice" do
    invoice = invoices(:invoice_one)
    assert invoice.valid?
  end

  test "amount must be positive" do
    invoice = invoices(:invoice_one)
    invoice.amount = -100
    assert_not invoice.valid?
  end

  test "status must be valid" do
    invoice = invoices(:invoice_one)
    invoice.status = "pending"
    assert_not invoice.valid?
  end

end
