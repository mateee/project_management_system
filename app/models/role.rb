class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :task
  has_one :one_task, through: :task
   
  validates :user_id, :presence => true,
                     :allow_blank => false
  validates :project_id, :presence => true,
                     :allow_blank => false

  validates :special, :length => {:maximum => 20}  
  validates :r_name, :presence => true
  validates_date :start_at, :allow_blank => true
  validates_date :end_at, :allow_blank => true
end
