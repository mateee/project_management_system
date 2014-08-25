module ProjectsHelper
    def join_tags(project)
    project.customer.map { |t| t.name }
  end
end
