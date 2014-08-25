class Notice < ActiveRecord::Base
  belongs_to :user
  
  # belongs_to :doer, class_name => 'User'
  # belongs_to :target, class_name => 'User'
end
