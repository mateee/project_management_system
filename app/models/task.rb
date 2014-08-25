class Task < ActiveRecord::Base
  belongs_to :project
  has_many :roles
  has_many :reports
  has_one :one_task, :dependent => :destroy
end
