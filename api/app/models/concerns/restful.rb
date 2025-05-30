module Restful
  extend ActiveSupport::Concern

  def resource_link
    "/#{self.class.resource_name}/#{self.id}"
  end

  class_methods do
    def resource_name
      self.name.pluralize.downcase
    end
  end
end