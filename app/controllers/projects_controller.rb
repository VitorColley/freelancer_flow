class ProjectsController < ApplicationController
  #allow_unauthenticated_access only: %i[index show]
  
  before_action :set_project, only: %i[ show edit update destroy ]
  #Makes sure only clients can manage Projects
  before_action :require_client, only: %i[ new create edit update destroy ]
  #Ensures only the owner can edit/delete
  before_action :authorize_project_owner, only: %i[edit update destroy]

  # GET /projects or /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1 or /projects/1.json
  def show
    if current_user&.client?
      # Client can only see proposals for THEIR project
      authorize_project_owner
      @proposals = @project.proposals.includes(:freelancer)
    elsif current_user&.freelancer?
      # Freelancer only sees their own proposal
      @proposals = @project.proposals.where(freelancer: current_user)
    else
      @proposals = Proposal.none
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
     @project = current_user.projects.build(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: "Project was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy!

    respond_to do |format|
      format.html { redirect_to projects_path, notice: "Project was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # Payment checkout action
  def checkout
    # Find the project
    project = Project.find(params[:id])
    # Initialize the payment processor
    processor = Payments::PaymentProcessor.new(project: project)
    # Create a checkout session
    session = processor.checkout!

    # Redirect to the payment gateway
    redirect_to session.url, allow_other_host: true
  # Handle payment errors
  rescue Payments::PaymentProcessor::PaymentError => e
    redirect_to project_path(project), alert: "Checkout failed: #{e.message}"
  end

  # Mark project as complete
  def complete
    project = Project.find(params[:id])

    accepted_proposal = project.proposals.find_by(status: "accepted")

    unless accepted_proposal&.freelancer == current_user
      redirect_to project,
                  alert: "Only the accepted freelancer can complete this project."
      return
    end

    Project.transaction do
      project.update!(status: "completed")

      # Auto-generate invoice
      unless project.invoice
        Invoice.create!(
          project: project,
          amount: project.budget,
          status: "unpaid"
        )
      end
    end

    redirect_to project, notice: "Project marked as completed. Invoice generated."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params.expect(:id))
    end

    # Only allow clients to manage projects
    def require_client
      return if current_user&.client?

      redirect_to projects_path, alert: "Only clients can manage projects."
    end

    #Only allows the owner to edit/delete
    def authorize_project_owner
      return if @project.client == current_user || current_user.admin?

      redirect_to projects_path, alert: "You are not authorised to modify this project."
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.expect(project: [ :title, :description, :budget, :status ])
    end
end
