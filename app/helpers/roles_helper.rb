module RolesHelper
  def project_and_user(role)
    if role.project_id.nil?
      role.errors.add(:project_id, "You must choose project for your role")
    end
  end
  
  def get_tasks(project1)
    @tasks1 = []
    @tasks.each do |t|
      if t.project.id == project1.id
        @tasks1.push(t)
      end
    end
    if @tasks1
      @tasks1 = @tasks1.sort_by {|ta| ta[:end_at]}
    end
  end
  
  def selected_value(t_id)
    print "GGGGGGGGGGGGGGGGGGf#{t_id}GGGGGGGGGGGGGGGGGGGG"
    print "dsdasdadasdasdasdadsadasdasda"
  end
end
