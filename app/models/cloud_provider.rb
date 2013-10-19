class CloudProvider < ActiveRecord::Base
  attr_accessible :key, :name, :provider, :secret, :type

  #To Make The Parent Class Aware of Its Children

  def self.select_options
    puts "#######{descendants.map{ |c| c.to_s }.sort}"
    descendants.map{ |c| c.to_s }.sort
  end

  def self.inherited(child)
    child.instance_eval do
      def model_name
        CloudProvider.model_name
      end
    end
    super
  end
end