class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[ show edit update destroy ]
  #authorises user to create an invoice
  before_action :authorise_invoice_creation, only: %i[ new create ]
  #authorises the owner of the invoice to modify it
  before_action :authorise_invoice_owner, only: %i[show edit update destroy]

  # GET /invoices or /invoices.json
  def index
    @invoices = Invoice.all
  end

  # GET /invoices/1 or /invoices/1.json
  def show
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices or /invoices.json
  def create
    @project = Project.find(params[:invoice][:project_id])
    @invoice = @project.build_invoice(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: "Invoice was successfully created." }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1 or /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to @invoice.project, notice: "Invoice was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1 or /invoices/1.json
  def destroy
    @invoice.destroy!

    respond_to do |format|
      format.html { redirect_to project_path(@invoice.project), notice: "Invoice was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params.expect(:id))
    end

    # Only the freelancer can create the invoice
    def authorise_invoice_creation
      project_id =
        params[:project_id] ||
        params.dig(:invoice, :project_id)

      project = Project.find(project_id)

      unless project.proposals.exists?(freelancer_id: current_user.id, status: "accepted")
        redirect_to projects_path, alert: "You are not allowed to invoice for this project."
      end
    end
    
    # Only the people involved in the project can edit/delete
    def authorise_invoice_owner
      project = @invoice.project

      # Gets freelancer
      accepted_freelancer = project.proposals.find_by(status: "accepted")&.freelancer

      return if project.client == current_user ||
                accepted_freelancer == current_user ||
                current_user&.admin?

      redirect_to project, alert: "You are not authorised to access this invoice."
    end

    # Only allow a list of trusted parameters through.
    def invoice_params
      params.expect(invoice: [ :amount, :status ])
    end
end
