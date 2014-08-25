class ReportsController < ApplicationController
  layout "main_page"
  before_filter :authorize, :authorize_company
  before_action :set_projects, only: [:index, :create, :week, :update_all, :create_all]
  before_action :before_week, only: [:week, :create_all, :update_all]
  before_action :before_index, only: [:index, :create]
  before_action :set_report, only: [:destroy]
  
  def before_week
    @tasks = Array.new
    @report = Report.new
    @reports= []
    @err = []
    @err1 = []
    @params_week = params[:week]
    
    @report1 = Report.new
    @reports1 = []
    5.times do ||
      @reports1.push(Report.new)
    end 
    
    if params[:week].nil? == false
      @reports = []
      @d = Date.new(Date.today.year,1,1)
      @rep = Report.where("user_id = ? AND date >= ?", current_user.id, @d).order(date: :desc)  
      @rep.each do |r|
        if r.date.cweek.to_i == params[:week].to_i && (r.approvement.nil? || r.approvement == 1)
          @reports.push(r)
        end
      end
    else
      @reports = []
      @d = Date.new(Date.today.year,1,1)
      @rep = Report.where("user_id = ? AND date >= ?", current_user.id, @d).order(date: :desc)  
      @rep.each do |r|
        if r.date.cweek.to_i == Date.today.cweek.to_i && (r.approvement.nil? || r.approvement == 1)
          @reports.push(r)
        end
      end
    end
  end
  
  def before_index
    @tasks = Array.new
    @report= Report.new
    @search_option = [false, true, false, false]
    @search_day = Time.now.strftime("%Y-%m-%d")
    @search_week = Date.today.cweek.to_i
    @search_month = Date.today.month
    @search_year = Date.today.year
    @search_from = nil
    @search_to = nil
        
    if params[:option].nil? == false
      @search_option = [false, false, false, false] 
      if params[:option] == '1'
        @search_day = params[:day].to_date
        @reports = Report.where(user_id: current_user.id, date: params[:day].to_date)
        @search_option[0] = true
      end
      if params[:option] == '2'
        @search_week = params[:week].to_i
        @search_option[1] = true
        @reports = []
        @d = Date.new(Date.today.year,1,1)
        @rep = Report.where("user_id = ? AND date >= ?", current_user.id, @d).order(date: :desc)  
        @rep.each do |r|
          if r.date.cweek.to_i == params[:week].to_i
            @reports.push(r)
          end
        end
      end
      if params[:option] == '3'
        @search_month = params[:month].to_i
        @search_year = params[:year].to_i
        @search_option[2] = true
        @reports = Report.where('user_id = ? AND extract(month from date) = ? AND extract(year from date) = ?',current_user.id, params[:month].to_i, params[:year].to_i).order(date: :desc)
      end
      if params[:option] == '4'
        @search_from = params[:from].to_date
        @search_to = params[:to].to_date
        @search_option[3] = true
        @range = (params[:from].to_date..params[:to].to_date)
        @reports = Report.where(user_id: current_user.id, date: @range).order(date: :desc)
      end
    else
      @d = Date.today
      @reports = Report.where('user_id = ? AND extract(month from date) = ? AND extract(year from date) = ?',current_user.id, @d.month.to_i, @d.year.to_i).order(date: :desc)
    end
    if @reports.nil?
      @reports = []
    end
    
    hours = @reports.any? ? @reports.map {|m| m.time.hour}.sum : 0
    minutes = @reports.any? ? @reports.map {|m| m.time.min}.sum : 0
    @sum = @reports.any? ? toClock(hours, minutes) : 0
  end
  
  def index
    # gon, for sending variables to js
    
    # @s_time1 = new
    # @s_time2 = new
    # @s_time3 = new
    # @s_time4 = new
    #     
    # gon.s_time = @s_time
    # gon.s_time1 = @s_time1
    # gon.s_time2 = @s_time2
    # gon.s_time3 = @s_time3
    # gon.s_time4 = @s_time4
    # gon.all_variables
  end
  
  def week
  end
  
  def new
    @report= Report.new
  end
  
  def approve
    if params[:format].nil? == false && params[:format].blank? == false
      params[:format].split("/").each do |id|
        @r = Report.find(id.to_i)
        # if @r.approvement.nil? == false
          # redirect_to week_reports_path, :alert => "You have already apprroved Report Week!" and return
        # end
        if @r.user_id != current_user.id
          redirect_to week_reports_path, :alert => "You are not authorized to perform this action!" and return
        end
      end
      params[:format].split("/").each do |id|
        @report = Report.find(id.to_i)
        if @report.update_attributes(:approvement => 1)
        else
          redirect_to week_reports_path, :alert => "There has been errors during apprrove Report Week." and return
        end
      end
    end 
    redirect_to reports_path, :notice => "Report Week has been successfully approved." and return
  end
  
  def create
    @report= Report.new(report_params)

    if params[:hours_id] == "02" && params[:minutes_id] == "00"
      if params[:object][:dur].blank? == false 
        @report.time = Time.strptime(params[:object][:dur], "%T") + 2.hours
        @report.time = @report.time - @report.time.sec
      end
    elsif params[:hours_id].nil? == false && params[:minutes_id].nil? == false
      t = params[:hours_id] + ":" + params[:minutes_id] + ":" +  "00"
      @report.time = Time.strptime(params[:hours_id] + ":" + params[:minutes_id] + ":" +  "00", "%T")
    end
    
    @report.user_id = current_user.id
    if @report.task_id
      @report.task_id = OneTask.find(@report.task_id).task.id
    end
    
    @report.valid?
    respond_to do |format|
      if @report.errors.any? == false && @report.save
        format.html { redirect_to reports_path, notice: 'Report was successfully created.' }
        format.json { render :index, status: :created, location: reports_path }
      else
        format.html { render :index }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def create_all
    @err = []
    @reports1 = []
    @id = current_user.id
    rs = params[:reports1]
    @i = 0
    rs.each do |val|
      if val[:task_id].nil? == false && val[:task_id].blank? == false
        @i += 1
        task = OneTask.find(val[:task_id].to_i).task.id
        if val[:hours_id].nil? == false && val[:minutes_id].nil? == false
          time = Time.strptime(val[:hours_id] + ":" + val[:minutes_id] + ":" +  "00", "%T") + 2.hours
        end
        @report1 = Report.new(user_id: @id, date: val[:date], time: time, info: val[:info], task_id: task)
        @reports1.push(@report1)
        @report1.valid?
        if @report1.user_id.nil?
          @report1.errors.add(:user_id, ": You must choose user")
        end
        if @report1.errors.any?
          @err.push(@i.to_s+". line")
          @report1.errors.full_messages.each do |message|
            @err.push(message)
          end
        end
      end   
    end 
    
    respond_to do |format|
      if @err.any? == false
        @reports1.each do |rpt|
          if rpt.save 
          else
            format.html { render :week }
            format.json { render json: @err, status: :unprocessable_entity }
          end
        end
        format.html { redirect_to reports_path, notice: 'Reports were successfully created.' }
        format.json { render :index, status: :created, location: reports_path }
      else
        format.html { render :week }
        format.json { render json: @err, status: :unprocessable_entity }
      end      
    end
  end
  
  def update_all
    @err1 = []
    @reports = []
    @id = current_user.id
    rs = params[:reports]
    @i = 0
    rs.each do |rpt, val|
      @i += 1
      if val[:task_id].nil? || val[:task_id].blank?
        @t_id = val[:helper]
      else
        @t_id = val[:task_id]
      end 
      task = OneTask.find(@t_id.to_i).task.id
      if val[:hours_id].nil? == false && val[:minutes_id].nil? == false
        time = Time.strptime(val[:hours_id] + ":" + val[:minutes_id] + ":" +  "00", "%T") + 2.hours
      end
      @report = Report.new(id: rpt ,user_id: @id, date: val[:date], time: time, info: val[:info], task_id: task,
                           created_at: Report.find(rpt).created_at, updated_at: Time.now)
      if @report.time?
        if @report.time.hour >= 12
          @report.time = @report.time - 12.hours
        end
      end
      @reports.push(@report)
      @report.valid?
      if @report.task_id.nil?
        @report.errors.add(:task_id, ": You must choose task")
      end
      if @report.user_id.nil?
        @report.errors.add(:user_id, ": You must choose user")
      end
      if @report.errors.any?
        @err1.push(@i.to_s+". line")
        @report.errors.full_messages.each do |message|
          @err1.push(message)
        end
      end
    end
      
    respond_to do |format|
      if @err1.any? == false
        @reports.each do |rpt|
          @rep = Report.find(rpt.id)
          if @rep.update(rpt.attributes) 
          else
            format.html { render :week }
            format.json { render json: @err1, status: :unprocessable_entity }
          end
        end
        format.html { redirect_to reports_path, notice: 'Reports were successfully updated.' }
        format.json { render :index, status: :created, location: reports_path }
      else
        format.html { render :week }
        format.json { render json: @err1, status: :unprocessable_entity }
      end      
    end
  end
       
  def task_depend
    if params[:project_id]
      @tasks = Project.find(params[:project_id]).one_tasks
    end 
    respond_to do |format|
      format.json { render :json => @tasks }
    end
  end
  
  def destroy
    if (@report.approvement.nil? == false && @report.approvement != 1) || @report.user_id != current_user.id
      redirect_to reports_path, alert: 'Report was already approved by PM or Verde, or you are trying to delete foreign report.'
    end
    
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_path, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
    
  private
  
  def set_projects
    if current_user.projects.distinct.size == 1
      @projects = []
      @projects = current_user.projects.distinct
    else
      @projects = current_user.projects.distinct
    end
  end
  
  def set_report
    @report = Report.find(params[:id])
  end
  
  def report_params
    params.require(:report).permit(:date, :time, :info, :user_id, :task_id, :helper, :approvement)
  end
  
end
