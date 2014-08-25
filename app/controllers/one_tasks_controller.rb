class OneTasksController < ApplicationController
  layout "main_page"
  before_filter :authorize, :authorize_company
  before_action :authorize_level, only: [:do_import, :import, :create, :new, :update, :update_all, :destroy, :delete, :edit, :index]
  before_action :set_one_task, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:import, :do_import, :update_all]
  before_action :check_project, only: [:import, :do_import, :update_all]
  before_action :check_project_task, only: [:show, :edit, :update, :destroy, :delete]
  
  def authorize_level
    if current_user.level != "VE" && current_user.level != "PM"
      redirect_to session[:return_to_project_show], :alert => "You are not authorized to perform this action!"
    end
  end
  
  def import
  end
  
  def show 
  end
  
  def edit
  end
  
  def do_import
      @err = []      
      @one_tasks = []    
      begin
      require 'fileutils'
      text = params[:file].read
      text.gsub!(/\r?\n/, "\n")
      text.each_line do |line|
        words = line.split(/(\t)/).delete_if{ |e| e == "\t" }
        
        work1 = words[4].scan(/\d/).join('') 
        duration_day1 = words[7].scan(/\d/).join('')
        words[8] == "Ano" ? milestone1 = true : milestone1 = false 
        words[14] == "Ano" ? joined_field1 = true : joined_field1 = false 
        words[15] == "Ano" ? congestion1 = true : congestion1 = false 
        words[17] == "Ano" ? managed_by_effort1 = true : managed_by_effort1 = false 
        words[18] == "Ano" ? hide_bar1 = true : hide_bar1 = false 
        words[23] == "Ano" ? equal_can_split_task1 = true : equal_can_split_task1 = false 
        words[24] == "Ano" ? equal_assign1 = true : equal_assign1 = false 
        words[30] == "Ano" ? assignment1 = true : assignment1 = false 
        @one_task = OneTask.new(guid: words[0], wbs_code: words[1], task_name: words[2], supply_name: words[3], work: work1, start_at: words[5], end_at: words[6], duration_day: duration_day1,
                    milestone: milestone1, wbs_code_child: words[9], wbs_code_parent: words[10], objects: words[11], parents: words[12], priority: words[13], joined_field: joined_field1,
                    congestion: congestion1, work_plan: words[16], managed_by_effort: managed_by_effort1, hide_bar: hide_bar1, source_group: words[19], state: words[20], sv: words[21].tr("^0-9,", '').tr(",", "."),
                    spi: words[22].tr(",", "."), equal_can_split_task: equal_can_split_task1, equal_assign: equal_assign1, accent_source: words[25], text1: words[26], owner_assign: words[27],
                    source_type: words[28], type_t: words[29], assignment: assignment1, source_names: words[31])

        @one_tasks.push(@one_task)   
      end
      rescue
        redirect_to import_one_task_path(@project), :alert => "There have been errors while uploading file! Probably bad format of file"
      end
  end
  
  def index
  end
  
  def update_all    
    @err = []
    @one_task = OneTask.new
    @i = 0
    tasks = params[:one_tasks]
    @one_tasks = []
    tasks.each do |tt|
      @ot = OneTask.new(guid: tt[:guid],wbs_code: tt[:wbs_code], task_name: tt[:task_name], supply_name: tt[:supply_name], work: tt[:work], start_at: tt[:start_at], end_at: tt[:end_at], duration_day: tt[:duration_day],
                              milestone: tt[:milestone], wbs_code_child: tt[:wbs_code_child], wbs_code_parent: tt[:wbs_code_parent], objects: tt[:objects], parents: tt[:parents], priority: tt[:priority], joined_field: tt[:joined_field],
                              congestion: tt[:ongestion], work_plan: tt[:work_plan], managed_by_effort: tt[:managed_by_effort], hide_bar: tt[:hide_bar], source_group: tt[:source_group], state: tt[:state], sv: tt[:sv],
                              spi: tt[:spi], equal_can_split_task: tt[:equal_can_split_task], equal_assign: tt[:equal_assign], accent_source: tt[:accent_source], text1: tt[:text1], owner_assign: tt[:owner_assign],
                              source_type: tt[:source_type], type_t: tt[:type_t], assignment: tt[:assignment], source_names: tt[:source_names])
      print "  ///////// #{@ot.attributes} /////////  "
      @one_tasks.push(@ot)
      @i += 1 
      @ot.valid?
      begin
        if @project.tasks.find_by(guid: @ot.guid).nil? && Task.find_by(guid: @ot.guid).nil? == false
          @err.push(@i.to_s+". line")
          @err.push("Same Task si already attached to another project, create new tasks in MS Project, or change guid to unique")
        end
      rescue
        redirect_to import_one_task_path(@project), :alert => "There have been errors while uploading file! Probably bad format of file" and return
      end
      if @ot.errors.any?
        @err.push(@i.to_s+". line")
        @ot.errors.full_messages.each do |message|
          @err.push(message)
        end
      end 
    end
    
    respond_to do |format|
      if @err.any? == false
        tasks.each do |tt|     
          @one_task = @project.one_tasks.find_by(guid: tt[:guid])     
          if @one_task.nil? && tt[:guid] != nil && tt[:task_name] != nil   
            @task = @project.tasks.new(guid: tt[:guid])
            @task.save
            @task = Task.find_by(guid: tt[:guid])

            if @task.create_one_task(guid: tt[:guid],wbs_code: tt[:wbs_code], task_name: tt[:task_name], supply_name: tt[:supply_name], work: tt[:work], start_at: tt[:start_at], end_at: tt[:end_at], duration_day: tt[:duration_day],
                              milestone: tt[:milestone], wbs_code_child: tt[:wbs_code_child], wbs_code_parent: tt[:wbs_code_parent], objects: tt[:objects], parents: tt[:parents], priority: tt[:priority], joined_field: tt[:joined_field],
                              congestion: tt[:ongestion], work_plan: tt[:work_plan], managed_by_effort: tt[:managed_by_effort], hide_bar: tt[:hide_bar], source_group: tt[:source_group], state: tt[:state], sv: tt[:sv],
                              spi: tt[:spi], equal_can_split_task: tt[:equal_can_split_task], equal_assign: tt[:equal_assign], accent_source: tt[:accent_source], text1: tt[:text1], owner_assign: tt[:owner_assign],
                              source_type: tt[:source_type], type_t: tt[:type_t], assignment: tt[:assignment], source_names: tt[:source_names])
            else
              redirect_to do_import_one_task_path(@project) , :alert => "There has been errors, check choosen data." and return
            end
          elsif tt[:guid] != nil && tt[:task_name] != nil 
            if @one_task.update(guid: tt[:guid],wbs_code: tt[:wbs_code], task_name: tt[:task_name], supply_name: tt[:supply_name], work: tt[:work], start_at: tt[:start_at], end_at: tt[:end_at], duration_day: tt[:duration_day],
                              milestone: tt[:milestone], wbs_code_child: tt[:wbs_code_child], wbs_code_parent: tt[:wbs_code_parent], objects: tt[:objects], parents: tt[:parents], priority: tt[:priority], joined_field: tt[:joined_field],
                              congestion: tt[:ongestion], work_plan: tt[:work_plan], managed_by_effort: tt[:managed_by_effort], hide_bar: tt[:hide_bar], source_group: tt[:source_group], state: tt[:state], sv: tt[:sv],
                              spi: tt[:spi], equal_can_split_task: tt[:equal_can_split_task], equal_assign: tt[:equal_assign], accent_source: tt[:accent_source], text1: tt[:text1], owner_assign: tt[:owner_assign],
                              source_type: tt[:source_type], type_t: tt[:type_t], assignment: tt[:assignment], source_names: tt[:source_names])
            else
              redirect_to do_import_one_task_path(@project) , :alert => "There has been errors, check choosen data." and return
            end
          end
        end 
        format.html { redirect_to import_one_task_path(@project), notice: 'Tasks One have been successfully Saved and Updated.' }
        format.json { render :index, status: :created, location: reports_path }
      else
        format.html { render :do_import }
        format.json { render json: @err, status: :unprocessable_entity }
      end 
    end
  end
  
  def update
    respond_to do |format|
      if @one_task.update(one_task_params)
        format.html { redirect_to one_task_path(@one_task), notice: 'Tasks One was successfully updated.' }
        format.json { render :show, status: :ok, location: one_task_path(@one_task) }
      else
        format.html { render :edit }
        format.json { render json: @one_task.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @task = @one_task.task
    @task.destroy
    respond_to do |format|
      format.html { redirect_to session[:return_to_project_show], notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
  
    def set_one_task
      @one_task = OneTask.find(params[:id])
    end
    
    def set_project
      @project= Project.find(params[:id])
    end
    
    def check_project_task
      if current_user.level != "VE"
        @projects = managerProjectConstraint()
        @project = @one_task.project
        if (@projects.include?(@project)) == false
          redirect_to session[:return_to_project_show], :alert => "You are not authorized to perform this action!"
        end
      end  
    end
    
    def check_project
      if current_user.level != "VE"
        @project_all = managerProjectConstraint()
        
        if (@project_all.include?(@project)) == false
          redirect_to projects_path, :alert => "You are not authorized to perform this action!"
        end
      end  
    end
  
    def one_task_params
      params.require(:one_task).permit(:guid, :wbs_code, :task_name, :supply_name, :work, :start_at, :end_at, :duration_day, :milestone,
            :wbs_code_child, :wbs_code_parent, :objects, :parents, :priority, :joined_field, :congestion, :work_plan, :managed_by_effort,
            :hide_bar, :source_group, :state, :sv, :spi, :equal_can_split_task, :equal_assign, :accent_source, :text1, :owner_assign, :source_type,
            :type_t, :assignment, :source_names, :task_id, tasks_attributes: [:guid])
    end
end
