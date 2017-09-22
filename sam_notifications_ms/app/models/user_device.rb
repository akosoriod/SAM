class UserDevice < ApplicationRecord  
  def self.get_device_id(username)
    select("device_id").where(username: username)
  end
end
