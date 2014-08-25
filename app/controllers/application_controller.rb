class ApplicationController < ActionController::Base
  include Clearance::Controller
   
  def authorize_company
    if current_user.level.nil?
      redirect_to :root, :alert => "Your account has not been activated!"
    end
  end
  
  def managerProjectConstraint()
    current_user.projects.where(roles: {special: "project_manager"})
  end
  
  def managerRoleConstraint()
    current_user.roles.where(special: "project_manager")
  end
  
  def getArchive()
  end
  
  def toClock(hours, minutes)
  h = hours + (minutes/60)  # hours
  m = minutes % 60 # minutes
  return "#{h}:#{m}:00"
end
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
