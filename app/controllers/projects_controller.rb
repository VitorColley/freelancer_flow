class ProjectsController < ApplicationController
  allow_unauthenticated_access only: %i[index show]
  
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
