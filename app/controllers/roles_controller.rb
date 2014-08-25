class RolesController < ApplicationController
  layout "main_page"
  before_filter :authorize, :authorize_company
  before_action :authorize_level, only: [:show, :create, :new, :new_task, :create_t_role, :update, :destroy, :delete, :edit, :index, :dofun]
  before_action :set_role, only: [:destroy, :edit, :update]
  before_action :set_projects, only: [:new, :create, :edit, :new_task, :create_t_role, :dofun, :proj_depend]
  before_action :set_users, only: [:new, :create, :edit, :new_task, :create_t_role]
  before_action :set_tasks, only: [:new_task, :create_t_role]
  
  def authorize_level
    if current_user.level != "VE" && current_user.level != "PM"
      redirect_to my_roles_path(@roles), :alert => "You are not authorized to perform this action!"
    end
  end
  
  def set_projects_s
    @projects_s = Project.find(params[:project_id])
    respond_to do |format|
      format.json { render :json => @projects_s }
      format.js
    end
  end
  
  def index      
    if params[:stat].nil? || params[:stat] == '1'
      if current_user.level == "PM"
        @projects = managerProjectConstraint().where(status: true)
      else
        @projects = Project.where(status: true)
      end
    else 
      if current_user.level == "PM"
        @projects = managerProjectConstraint()
      else
        @projects = Project.all
      end
    end
    
    if ((params[:project_id].nil?) == false) && (params[:project_id].empty? == false)
      @proj = Project.find(params[:project_id])
    else
      if current_user.level == "PM"
        @proj = managerProjectConstraint().where(status: true)
      else 
        @proj = Project.where(status: true)
      end 
    end
  end
  
  def edit
    if current_user.level == "PM" && current_user.roles.where(special: "project_manager").include?(r) == false
      redirect_to roles_path, :alert => "You are not authorized to perform this action!"
    end
  end
  
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to role_path(@role.user_id), notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: role_path(@role.user_id) }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def dofun        
    if (params[:project_id].nil?)== false
      @tasks11 = Project.find(params[:project_id]).one_tasks
      respond_to do |format|
        format.json { render :json => @tasks11 }
      end
    else
      
    end   
  end
  
  def proj_depend
    if (params[:user_id].nil?)== false
      @projects11 = []
      @projec = User.find(params[:user_id]).projects
      @projects.each do |proj|
          if @projec.include?(proj) && proj.one_tasks.any?
            @projects11.push(proj) 
          end
      end
      respond_to do |format|
        format.json { render :json => @projects11 }
      end
    end    
  end
  
  def myroles
    @user = current_user
    @roles = @user.roles.where(task_id: nil)
  end
  
  def show
    @user = User.find(params[:id])
    if current_user.level == "PM"
      @roles = []
      @t = current_user.roles.where(special: "project_manager").order(id: :asc)
      if @t.any? && @user.level != "VE"
        @range = @t.map {|m| m.project_id}
        @roles = @user.roles.where(task_id: nil, project_id: @range)
      end
    else
      @roles = @user.roles.where(task_id: nil)  
    end
  end
  
  def new
    @role = Role.new
  end
  
  def new_task
    @role = Role.new
    @idecko = params[:task_id]
  end
  
  def create
    @check = 0
    @role = Role.new(role_params)
    @role.valid?
    if @role.project_id.nil? == false && @role.user_id.nil? == false
      if Role.where(user_id: @role.user_id, project_id: @role.project_id).any?
        @role.errors.add(:project_id, ": User is already attached to this project")
      end
    end   
    if @role.special.nil? == false && @role.user.nil? == false
      if @role.special == "project_manager" && @role.user.level != "PM"
        @check = 1
      end
    end

    respond_to do |format|
      if @role.errors.any? == false && (@role.project_id.nil?) == false && @check == 0
        if @role.save
          format.html { redirect_to roles_path, notice: 'Role was successfully created.' }
          format.json { render :index, status: :created, location: roles_path }
        else
          format.html { render :new }
          format.json { render json: @role.errors, status: :unprocessable_entity }
        end
      else
        if @check == 1  
          @role.errors.add(:special, ": You can not choose user as project manager, because he does not have level of Project Manager")
        end
        if @role.project_id.nil?
          @role.errors.add(:project_id, ": You must choose project for your role")
        end
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def create_t_role
    @role = Role.new(role_params)
    if @role.task_id
      t_id = OneTask.find(@role.task_id).task.id
      @role.task_id = t_id
    end
    
    respond_to do |format|
      if (@role.task_id.nil?) == false && (@role.project_id.nil?) == false
        if @role.save
          format.html { redirect_to roles_path, notice: 'Task was successfully assigned.' }
          format.json { render :index, status: :created, location: roles_path }
        else
          format.html { render :new_task }
          format.json { render json: @role.errors, status: :unprocessable_entity }
        end
      else
        if @role.task_id.nil?
          @role.errors.add(:task_id, ": You must choose task for your role")
        end
        if @role.project_id.nil?
          @role.errors.add(:project_id, ": You must choose project for your role")
        end
        format.html { render :new_task }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    if current_user.level == "PM"
      if managerProjectConstraint().include?(@role.project) == false
        redirect_to roles_path, :alert => "You are not authorized to perform this action!" and return
      end
    end
    
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_path, notice: 'User was successfully removed from project.' }
      format.json { head :no_content }
    end
  end
  
  private
  
    def get_path
      current_uri = request.env['PATH_INFO']
    end
  
    def set_role
      @role = Role.find(params[:id])
    end
    
    def set_projects
      if current_user.level == "PM"
        @projects = managerProjectConstraint().where(status: true)
      else
        @projects = Project.where(status: true)
      end
    end
    
    def set_tasks      
      if current_user.level == "PM"
        @tasks = []
        @projects.each do |proj|
          if proj.one_tasks
            proj.one_tasks.each do |t|
              if (t.task_name.blank?) == false
                @tasks.push(t) 
              end     
            end
          end
        end
      else
        @tasks = OneTask.joins(project: :tasks).distinct.where("task_name IS NOT NULL")
      end
    end
    
    def set_users
      if current_user.level == "PM"
        @users = User.where("last_name != ''").where(status: true).where("id != ?", current_user.id)
      else
        @users = User.where("last_name != ''").where(status: true)
      end
    end
  
    def role_params
      params.require(:role).permit(:id, :r_name, :start_at, :end_at, :state, :user_id, :project_id, :task_id, :special)
    end
end
