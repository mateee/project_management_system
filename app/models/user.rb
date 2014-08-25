class User < ActiveRecord::Base
  include Clearance::User
  has_many :notices, :dependent => :destroy
  # has_many :doer_notices, :class_name => 'Notice', :foreign_key => 'doer_id', :dependent => :destroy
  # has_many :target_notices, :class_name => 'Notice', :foreign_key => 'target_id', :dependent => :destroy
  has_many :roles, :dependent => :destroy
  has_many :reports, :dependent => :destroy
  has_many :projects, through: :roles
  has_many :customers, through: :projects
  has_many :tasks, through: :roles
  has_many :one_tasks, through: :tasks
  
  after_initialize :init, :if => :new_record?

    def init
      self.status  ||= true     #will set the default value only if it's nil
    end
    
  def full_name
    "#{first_name} #{last_name}"
  end

  validates :first_name, :length => {:maximum => 20}
  validates :last_name, :length => {:maximum => 20}
  validates :work_day, :numericality => { only_float: true },
                      :allow_nil => true
  validates :level, :length => {:maximum => 2}
  validates :email, :length => {:maximum => 50}
  validates :city, :length => {:maximum => 40}
  validates :title, :length => {:maximum => 15}
  validates :acquirements, :length => {:maximum => 40}
end
