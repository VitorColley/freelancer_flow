class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[show edit update destroy]
  before_action :authorise_invoice_creation, only: %i[new create]
  before_action :authorise_invoice_owner, only: %i[show edit update destroy]

  # GET /invoices
  def index
    @invoices =
      if current_user.client?
        Invoice.joins(:project)
               .where(projects: { client_id: current_user.id })
      elsif current_user.freelancer?
        Invoice.where(freelancer: current_user)
      else
        Invoice.none
      end
  end

  # GET /invoices/1
  def show
  end

  # GET /invoices/new?project_id=1
  def new
    @project = Project.find(params[:project_id])
    @invoice = @project.build_invoice
  end

  # POST /invoices
  def create
    @project = Project.find(params[:invoice][:project_id])
    @invoice = @project.build_invoice(invoice_params)

    # Assign parties automatically
    @invoice.client = @project.client
    @invoice.freelancer =
      @project.proposals.find_by(status: "accepted")&.freelancer

    if @invoice.save
      redirect_to @invoice, notice: "Invoice was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /invoices/1/edit
  def edit
  end

  # PATCH/PUT /invoices/1
  def update
    if @invoice.update(invoice_params)
      redirect_to @invoice.project,
                  notice: "Invoice was successfully updated.",
                  status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /invoices/1
  def destroy
    project = @invoice.project
    @invoice.destroy
    redirect_to project,
                notice: "Invoice was successfully destroyed.",
                status: :see_other
  end

  def checkout
    invoice = Invoice.find(params.expect(:id))
    project = invoice.project

    unless project.client == current_user
      redirect_to invoice, alert: "You are not authorised to pay this invoice."
      return
    end

    processor = Payments::PaymentProcessor.new(project: project)

    session = processor.checkout!

    redirect_to session.url, allow_other_host: true
  rescue Payments::PaymentProcessor::PaymentError => e
    redirect_to invoice, alert: e.message
  end


  private

  # Load invoice
  def set_invoice
    @invoice = Invoice.find(params.expect(:id))
  end

  # Only accepted freelancer can create invoice
  def authorise_invoice_creation
    project_id =
      params[:project_id] ||
      params.dig(:invoice, :project_id)

    project = Project.find(project_id)

    unless project.proposals.exists?(
      freelancer_id: current_user.id,
      status: "accepted"
    )
      redirect_to projects_path,
                  alert: "You are not allowed to invoice for this project."
    end
  end

  # Only client or accepted freelancer can view/edit
  def authorise_invoice_owner
    project = @invoice.project
    accepted_freelancer =
      project.proposals.find_by(status: "accepted")&.freelancer

    return if project.client == current_user ||
              accepted_freelancer == current_user ||
              current_user&.admin?

    redirect_to project,
                alert: "You are not authorised to access this invoice."
  end

  # Strong parameters
  def invoice_params
    params.expect(invoice: [:amount, :status])
  end
end
