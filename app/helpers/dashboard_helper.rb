module DashboardHelper
  def getWeeks()
    @p = Date.new(Date.today.year,12,31)
    @p.strftime("%W").to_i
  end
  
  def pmProjects()
    @pm_projects = current_user.projects.distinct
  end
  
  def getId_s()
    @id_s = []
    @reports.each do |report|
      @id_s.push(report.id)
    end
    return @id_s
  end
end
