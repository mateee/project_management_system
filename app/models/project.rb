class Project < ActiveRecord::Base
  belongs_to :customer
  has_many :roles, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :users, through: :roles
  has_many :one_tasks, through: :tasks
  has_many :reports, through: :tasks
  
  after_initialize :init, :if => :new_record?
  
  def init
    self.status  ||= true     #will set the default value only if it's nil
  end
  
  validates :customer_id, :presence => true
  validates :name, :length => {:maximum => 50},
                    :presence => true                    
  validates_date :start_at, :allow_blank => true
  validates_date :end_at, :allow_blank => true
  validates :budget, :numericality => { only_decimal: true },
                     :allow_nil => true
                      
  
end
