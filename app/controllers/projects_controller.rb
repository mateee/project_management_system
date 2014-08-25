class ProjectsController < ApplicationController
  layout "main_page"
  before_filter :authorize, :authorize_company
  before_action :authorize_level, only: [:create, :new, :update, :destroy, :delete, :edit]
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  
  def authorize_level
    if current_user.level != "VE"
      redirect_to projects_path, :alert => "You are not authorized to perform this action!"
    end
  end
  
  def index
    if params[:stat].nil? || params[:stat] == '1'
      @archive_value = [true, false]
      if current_user.level != "VE"
        @project = managerProjectConstraint().where(status: true)
      else
        @project = Project.where(status: true)
      end
    else 
      @archive_value = [false, true]
      if current_user.level != "VE"
        @project = managerProjectConstraint()
      else
        @project = Project.all
      end
    end
  end
  
  def show
    if current_user.level != "VE"
      @project_all = managerProjectConstraint()
      if (@project_all.include?(@project)) == false
        redirect_to projects_path, :alert => "You are not authorized to perform this action!"
      end
    end  
    @one_tasks = @project.one_tasks.all.order(wbs_code: :asc)
    
    # begin
      # session.delete(session[:return_to_project_show])
    # end 
    session[:return_to_project_show] = project_path(@project)
  end
  
  def edit
    @customers = Customer.all.where(status: true)
  end
  
  def new
    @project = Project.new
    @customers = Customer.all.where(status: true)
  end
  
  def create
    @customers = Customer.all.where(status: true)
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @customers = Customer.all.where(status: true)
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_path(@project), notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: customer_path(@project) }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_path, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
  
    def set_project
      @project= Project.find(params[:id])
    end
  
    def project_params
      params.require(:project).permit(:name, :info, :start_at, :end_at, :budget, :status, :customer_id)
    end
end
