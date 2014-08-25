class OneTask < ActiveRecord::Base
  belongs_to :task
  has_one :project, through: :task
  has_many :roles, through: :task
  has_many :users, through: :roles
  
  def project_task_name
    name = OneTask(id).project.name
    print "ffffffffffff#{name} #{task_name}fffffffffffffffff"
    "#{name} #{task_name}"
  end
  
  validates :guid, :presence => true
  validates :task_name, :presence => true
  validates :wbs_code, :length => {:maximum => 150}
  validates :wbs_code_child, :length => {:maximum => 150}
  validates :wbs_code_parent, :length => {:maximum => 150}
  validates :state, :length => {:maximum => 50}
  validates :source_type, :length => {:maximum => 100}
  validates :type_t, :length => {:maximum => 50}  
  validates_date :start_at, :allow_blank => true
  validates_date :end_at, :allow_blank => true
  validates :work, :numericality => { only_integer: true },
                     :allow_nil => true
  validates :duration_day, :numericality => { only_integer: true },
                     :allow_nil => true
  validates :objects, :numericality => { only_integer: true },
                     :allow_nil => true
  validates :parents, :numericality => { only_integer: true },
                     :allow_nil => true
  validates :priority, :numericality => { only_integer: true },
                     :allow_nil => true
  validates :sv, :numericality => { only_decimal: true },
                     :allow_nil => true
  validates :spi, :numericality => { only_float: true },
                     :allow_nil => true
                     
  accepts_nested_attributes_for :task
end
