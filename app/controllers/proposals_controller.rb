class ProposalsController < ApplicationController
  before_action :set_proposal, only: %i[ show edit update destroy ]
  #Ensures only freelancers can manage proposals
  before_action :require_freelancer, only: %i[ new create]
  #Ensures only the owner can edit/delete
  before_action :authorize_proposal_owner, only: %i[edit update destroy]

  # GET /proposals or /proposals.json
  def index
    @proposals = Proposal.all
  end

  # GET /proposals/1 or /proposals/1.json
  def show
  end

  # GET /proposals/new
  def new
    @proposal = Proposal.new
  end

  # GET /proposals/1/edit
  def edit
  end

  # POST /proposals or /proposals.json
  def create
    @proposal = current_user.proposals.build(proposal_params)
    @proposal.project = @project

    respond_to do |format|
      if @proposal.save
        format.html { redirect_to @proposal, notice: "Proposal was successfully created." }
        format.json { render :show, status: :created, location: @proposal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proposals/1 or /proposals/1.json
  def update
    respond_to do |format|
      if @proposal.update(proposal_params)
        format.html { redirect_to @proposal, notice: "Proposal was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @proposal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proposals/1 or /proposals/1.json
  def destroy
    @proposal.destroy!

    respond_to do |format|
      format.html { redirect_to proposals_path, notice: "Proposal was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proposal
      @proposal = Proposal.find(params.expect(:id))
    end

    # Only allow the Owner to edit/delete
    def authorize_proposal_owner
      return if @proposal.freelancer == current_user || current_user&.admin?

      redirect_to project_path(@proposal.project),
                  alert: "You are not authorised to modify this proposal."
    end

    # Only allow a list of trusted parameters through.
    def proposal_params
      params.expect(proposal: [:message, :bid_amount])
    end
end
