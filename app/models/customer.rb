class Customer < ActiveRecord::Base
  has_many :projects, :dependent => :nullify
  
  after_initialize :init, :if => :new_record?

  def init
    self.status  ||= true     #will set the default value only if it's nil
  end
  
  validates_associated :projects
  validates :name, :length => {:maximum => 50},
                    :presence => true
  validates :adress, :length => {:maximum => 30}
  validates :city, :length => {:maximum => 20}
  validates :post_code, :length => {:maximum => 10}
  validates :country, :length => {:maximum => 20}
  validates :mobile, :length => {:maximum => 20}
end
