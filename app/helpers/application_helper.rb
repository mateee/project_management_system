module ApplicationHelper
  def show_status(state)
    if state == true
      "Active"
    else
      "Archived"
    end
  end
end
