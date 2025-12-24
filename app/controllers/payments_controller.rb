class PaymentsController < ApplicationController
  def success
    session_id = params[:session_id]

    # Retrieve session from Stripe
    session = Stripe::Checkout::Session.retrieve(session_id)

    project_id = session.metadata["project_id"]
    project = Project.find(project_id)

    # Mark invoice as paid
    if project.invoice&.status != "paid"
      project.invoice.update!(status: "paid")
    end

    redirect_to project.invoice, notice: "Payment successful. Invoice marked as paid."
  end

  def cancel
    redirect_to invoices_path, alert: "Payment was cancelled."
  end
end
