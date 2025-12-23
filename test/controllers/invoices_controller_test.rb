require "test_helper"

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invoice = invoices(:invoice_one)
    @project = @invoice.project

    @freelancer = users(:freelancer_one)
    @other_freelancer = users(:freelancer_two)
    @client = users(:client_one)
  end

  test "index is protected and redirects unauthenticated users to login" do
    get invoices_url
    assert_redirected_to new_session_path
  end

  test "freelancer cannot access new invoice page without project context" do
    sign_in_as(@freelancer)

    get new_invoice_url
    assert_response :not_found
  end

  test "client cannot access new invoice page" do
    sign_in_as(@client)

    get new_invoice_url
    assert_response :not_found
  end

  test "freelancer cannot create second invoice for same project" do
    sign_in_as(@freelancer)

    assert_no_difference("Invoice.count") do
      post invoices_url, params: {
        invoice: {
          amount: 1500,
          project_id: @project.id
        }
      }
    end
  end

  test "client cannot create invoice" do
    sign_in_as(@client)

    post invoices_url, params: {
      invoice: {
        amount: 1500,
        project_id: @project.id
      }
    }

    assert_redirected_to projects_path
  end

  test "invoice owner can view invoice" do
    sign_in_as(@freelancer)

    get invoice_url(@invoice)
    assert_response :success
  end

  test "invoice client can view invoice" do
    sign_in_as(@invoice.project.client)

    get invoice_url(@invoice)
    assert_response :success
  end

  test "non-owner freelancer cannot edit invoice" do
    sign_in_as(@other_freelancer)

    get edit_invoice_url(@invoice)
    assert_redirected_to project_path(@project)
  end

  test "invoice owner can update invoice" do
    sign_in_as(@freelancer)

    patch invoice_url(@invoice), params: {
      invoice: {
        amount: 6000
      }
    }

    assert_redirected_to project_path(@project)
  end

  test "invoice owner can destroy invoice" do
    sign_in_as(@freelancer)

    assert_difference("Invoice.count", -1) do
      delete invoice_url(@invoice)
    end

    assert_redirected_to project_path(@project)
  end

  test "non-owner freelancer cannot destroy invoice" do
    sign_in_as(@other_freelancer)

    delete invoice_url(@invoice)
    assert_redirected_to project_path(@project)
  end
end
