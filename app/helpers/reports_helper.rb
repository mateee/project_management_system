module ReportsHelper
  def getWeeks()
    @p = Date.new(Date.today.year,12,31)
    @p.strftime("%W").to_i
  end
  
  def getId_s()
    @id_s = []
    @reports.each do |report|
      @id_s.push(report.id)
    end
    return @id_s
  end
  
  def selectedTask(report)
    if report.user_id? == false
      @blank = "Select Task"
      @selected = nil
    else
      @blank = report.task.one_task.task_name
      @selected = report.task.one_task.id
    end
  end
  
  def selectedProject(report)
    if report.user_id? == false
      @prompt = "Select Project"
    else
      @prompt = report.project.name
    end
  end
  
  def getSelectedWeek()
    if @params_week.nil?
      @params_week = Date.today.cweek.to_i
    end
  end
  
  def selectedTime(report)
    report.time? ? @selected_time = (report.time.strftime("%H:%M:%S")).to_time : @selected_time = nil
  end
end
