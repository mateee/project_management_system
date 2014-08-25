class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  has_one :project, through: :task
  
  attr_accessor :hours_id, :minutes_id
  
  validates_date :date,
                  :presence => true
  validates_time :time,
                  :presence => true
  validates :task_id, :presence => true,
                      :allow_blank => false                 
  validates :user_id, :presence => true,
                      :allow_blank => false
end
