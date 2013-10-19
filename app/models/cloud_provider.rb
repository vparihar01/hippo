class CloudProvider < ActiveRecord::Base
  attr_accessible :key, :name, :provider, :secret
end
