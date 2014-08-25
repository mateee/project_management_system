class TasksController < ApplicationController
  
  
  private
  
    def task_params
      params.require(:task).permit(:guid)
    end
end
