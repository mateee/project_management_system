class DashboardController < ApplicationController
  layout "main_page"
  before_filter :authorize, :authorize_company
  before_filter :authorize_level, except: :index
  before_filter :authorize_verde, only: :verde_approve
  before_action :set_projects, only: [:reports]
  before_action :set_users, only: [:reports]
  
  def authorize_level
    if current_user.level != "VE" && current_user.level != "PM"
      redirect_to dashboard_index_path, :alert => "You are not authorized to perform this action!"
    end
  end
  
  def authorize_verde
    if current_user.level != "VE"
      redirect_to dashboard_index_path, :alert => "You are not authorized to perform this action!"
    end
  end
  
  def index
  end
  
  def reports
    @tasks = Array.new
    @report = Report.new
    @approve_u = 0
    @search_option = [false, true, false, false]
    @search_day = Time.now.strftime("%Y-%m-%d")
    @search_week = Date.today.cweek.to_i
    @search_month = Date.today.month
    @search_year = Date.today.year
    @search_from = nil
    @search_to = nil
    @search_project = nil
    @search_user = nil
    
    if params[:option].nil? == false
      @search_project = params[:project_id].to_i
      @search_user = params[:user_id].to_i
      @search_option = [false, false, false, false] 
      if params[:project_id].blank? == false
        @t = Project.find(params[:project_id]).tasks.order(id: :asc)
        @range = @t.map {|m| m.id}
      end

      if params[:option] == '1'   
        @search_day = params[:day].to_date
        @search_option[0] = true
        if params[:project_id].blank? && params[:user_id].blank?
          @reports = Report.where(date: params[:day].to_date)
        end
        if params[:project_id].blank? == false && params[:user_id].blank?
          @reports = Report.where(task_id: @range, date: params[:day].to_date)
        end
        if params[:project_id].blank? && params[:user_id].blank? == false
          @reports = Report.where(user_id: params[:user_id], date: params[:day].to_date)
        end
        if params[:project_id].blank? == false && params[:user_id].blank? == false
          @reports = Report.where(user_id: params[:user_id],task_id: @range, date: params[:day].to_date)
        end       
      end
      
      if params[:option] == '2'
        @search_week = params[:week].to_i
        @search_option[1] = true
        @reports = []
        @d = Date.new(Date.today.year,1,1)
        if params[:project_id].blank? && params[:user_id].blank?
          @rep = Report.where("date >= ?", @d).order(date: :desc)
        end
        if params[:project_id].blank? == false && params[:user_id].blank?
          @rep = Report.where(task_id: @range).where("date >= ?", @d).order(date: :desc)
        end
        if params[:project_id].blank? && params[:user_id].blank? == false
          @rep = Report.where(user_id: params[:user_id]).where("date >= ?", @d).order(date: :desc)
          @approve_u = 1
          
          #for user - week, show all his roles
          @user = User.find(@search_user)
          if current_user.level == "PM"
            @t = current_user.roles.where(special: "project_manager").order(id: :asc)
            if @t.any?
              @range = @t.map {|m| m.id}
              @roles = @user.roles.where(task_id: nil, id: @range)
            end
          else
            @roles = @user.roles.where(task_id: nil)  
          end
        
        end
        if params[:project_id].blank? == false && params[:user_id].blank? == false
          @rep = Report.where(user_id: params[:user_id],task_id: @range).where("date >= ?", @d).order(date: :desc)
        end
          
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
        if params[:project_id].blank? && params[:user_id].blank?
          @reports = Report.where('extract(month from date) = ? AND extract(year from date) = ?', params[:month].to_i, params[:year].to_i).order(date: :desc)
        end
        if params[:project_id].blank? == false && params[:user_id].blank?
          @reports = Report.where(task_id: @range).where('extract(month from date) = ? AND extract(year from date) = ?', 
            params[:month].to_i, params[:year].to_i).order(date: :desc)
        end
        if params[:project_id].blank? && params[:user_id].blank? == false
          @reports = Report.where(user_id: params[:user_id]).where('extract(month from date) = ? AND extract(year from date) = ?', 
            params[:month].to_i, params[:year].to_i).order(date: :desc)
        end
        if params[:project_id].blank? == false && params[:user_id].blank? == false
          @reports = Report.where(user_id: params[:user_id],task_id: @range).where('extract(month from date) = ? AND extract(year from date) = ?', 
            params[:month].to_i, params[:year].to_i).order(date: :desc)
        end
      end
      
      if params[:option] == '4'
        @search_from = params[:from].to_date
        @search_to = params[:to].to_date
        @search_option[3] = true
        @range1 = (params[:from].to_date..params[:to].to_date)
        if params[:project_id].blank? && params[:user_id].blank?
          @reports = Report.where(date: @range1).order(date: :desc)
        end
        if params[:project_id].blank? == false && params[:user_id].blank?
          @reports = Report.where(task_id: @range, date: @range1).order(date: :desc)
        end
        if params[:project_id].blank? && params[:user_id].blank? == false
          @reports = Report.where(user_id: params[:user_id], date: @range1).order(date: :desc)
        end
        if params[:project_id].blank? == false && params[:user_id].blank? == false
          @reports = Report.where(task_id: @range, user_id: params[:user_id], date: @range1).order(date: :desc)
        end
      end
      
      if current_user.level == "PM"
        @help = []
        @reports.each do |rp|
          if @projects.include?(rp.project)
            @help.push(rp)
          end
        end
        @reports = @help
      end
    end
    if @reports.nil?
      @reports = []
    end
    
    hours = @reports.any? ? @reports.map {|m| m.time.hour}.sum : 0
    minutes = @reports.any? ? @reports.map {|m| m.time.min}.sum : 0
    @sum = @reports.any? ? toClock(hours, minutes) : 0
  end
  
  def approve_all
    check = 0
    params[:reports].each do |rpt, val|
      if val[:approvement].nil? == false && val[:approvement] == "1"
        check = 1
        @r = Report.find(rpt.to_i)
        if @r.update_attributes(:approvement => 2)
        else
          redirect_to dashboard_reports_path, :alert => "There has been errors during apprrove Report Week." and return
        end
      end
    end
    if check == 0
      redirect_to dashboard_reports_path, :alert => "There has been errors during apprrove Report Week." and return
    else
      redirect_to dashboard_reports_path, :notice => "Report Week has been successfully approved to LEVEL: 2." and return
    end
  end
  
  def verde_approve
    if params[:format].nil? == false && params[:format].blank? == false
      # params[:format].split("/").each do |id|
        # @r = Report.find(id.to_i)
        # if @r.approvement == 3
          # redirect_to dashboard_reports_path, :alert => "You have already apprroved Report Week!" and return
        # end
      # end
      params[:format].split("/").each do |id|
        @r = Report.find(id.to_i)
        if @r.update_attributes(:approvement => 3)
        else
          redirect_to dashboard_reports_path, :alert => "There has been errors during apprrove Report Week." and return
        end
      end
    else
      redirect_to dashboard_reports_path, :alert => "There has been errors during apprrove Report Week." and return
    end   
    redirect_to dashboard_reports_path, :notice => "Report Week has been successfully approved." and return
  end
  
  private
  
  def set_projects
    if current_user.level == "PM"
      @projects = managerProjectConstraint()
    else
      @projects = Project.all
    end
    if @projects.nil?
      @projects = []
    end
  end
  
  def set_users
    if current_user.level == "PM"
      @users = []
        @projects.each do |proj|
          if proj.roles
            proj.roles.where("task_id IS NULL").each do |role|
              if @users.any? == false
                if role.user.last_name.blank? == false && role.user_id != current_user.id && role.user.level != "VE"
                  @users.push(role.user)
                end  
              elsif @users.include?(role.user) == false && role.user.last_name.blank? == false && role.user_id != current_user.id && role.user.level != "VE"
                @users.push(role.user)
              end
            end
          end
        end
    else
      @users = User.where("last_name != ''") 
    end
  end
  
end
