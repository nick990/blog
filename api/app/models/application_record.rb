class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  
  def resource_name
    self.class.name.pluralize.downcase
  end

  def resource_link
    "/#{resource_name}/#{self.id}"
  end
end
