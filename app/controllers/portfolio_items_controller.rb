class PortfolioItemsController < ApplicationController
  allow_unauthenticated_access only: %i[index show]

  before_action :set_portfolio_item, only: %i[ show edit update destroy ]
  # Only freelancers can create
  before_action :require_freelancer
  # Only owner can edit/delete
  before_action :authorize_portfolio_owner, only: %i[edit update destroy]

  # GET /portfolio_items or /portfolio_items.json
  def index
    @portfolio_items = PortfolioItem.all
  end

  # GET /portfolio_items/1 or /portfolio_items/1.json
  def show
  end

  # GET /portfolio_items/new
  def new
    @portfolio_item = PortfolioItem.new
  end

  # GET /portfolio_items/1/edit
  def edit
  end

  # POST /portfolio_items or /portfolio_items.json
  def create
    @portfolio_item = current_user.portfolio_items.build(portfolio_item_params)

    respond_to do |format|
      if @portfolio_item.save
        format.html { redirect_to @portfolio_item, notice: "Portfolio item was successfully created." }
        format.json { render :show, status: :created, location: @portfolio_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @portfolio_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /portfolio_items/1 or /portfolio_items/1.json
  def update
    respond_to do |format|
      if @portfolio_item.update(portfolio_item_params)
        format.html { redirect_to @portfolio_item, notice: "Portfolio item was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @portfolio_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @portfolio_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /portfolio_items/1 or /portfolio_items/1.json
  def destroy
    @portfolio_item.destroy!

    respond_to do |format|
      format.html { redirect_to portfolio_items_path, notice: "Portfolio item was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_portfolio_item
      @portfolio_item = PortfolioItem.find(params.expect(:id))
    end

    # Only owner can edit/delete
    def authorize_portfolio_owner
      return if @portfolio_item.freelancer == current_user || current_user&.admin?

      redirect_to portfolio_items_path,
                  alert: "You are not authorised to modify this portfolio item."
    end

    # Only allow a list of trusted parameters through.
    def portfolio_item_params
      params.expect(portfolio_item: [ :title, :description, :url ])
    end
end
