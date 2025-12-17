class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show edit update destroy ]
  #authorises user to create a review
  before_action :authorise_review_creation, only: %i[ new create ]
  #authorises the owner of the review to modify it
  before_action :authorize_owner, only: %i[edit update destroy]


  # GET /reviews or /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1 or /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews or /reviews.json
  def create
    @review = Review.new(review_params)

    respond_to do |format|
      if @review.save
        format.html { redirect_to @review, notice: "Review was successfully created." }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: "Review was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1 or /reviews/1.json
  def destroy
    @review.destroy!

    respond_to do |format|
      format.html { redirect_to reviews_path, notice: "Review was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params.expect(:id))
    end

    # Only authorises the owner of the project or the freelancer who was involved to create a review
    def authorise_review_creation
      project = Project.find(params[:project_id])
      
      #Check if the review is completed
      unless project.status == "completed"
        redirect_to project, alert: "Reviews can only be left on completed projects."
        return
      end

      #Check client
      return if project.client == current_user

      accepted_proposal = project.proposals.find_by(
        freelancer: current_user,
        status: "accepted"
      )

      # Check freelancer
      return if accepted_proposal

      redirect_to root_path, alert: "You are not allowed to review this project."
    end

    # Only allow the creator to edit/delete
    def authorize_owner
      return if @review.reviewer == current_user || current_user.admin?

      redirect_to @review.project, alert: "You are not authorised to modify this review."
    end

    # Only allow a list of trusted parameters through.
    def review_params
      params.expect(review: [ :project_id, :reviewer_id, :reviewee_id, :rating, :comment ])
    end
end
