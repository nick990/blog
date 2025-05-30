module Sortable
  extend ActiveSupport::Concern
  
  included do
    ORDERING_FALLBACK = {id: :desc}.freeze
    class_attribute :ordering_default, default: ORDERING_FALLBACK
  end
  
  class_methods do

    # options[:default] : Custom default ordering
    def sortable(options = {})
      if options[:default]    
        # If the custom default ordering contains the same field as the ORDERING_FALLBACK, use the custom default ordering
        # Otherwise, merge the custom default ordering with the ORDERING_FALLBACK (as last element)
        self.ordering_default = options[:default].key?(ORDERING_FALLBACK.keys.first) ? 
          options[:default] : 
          options[:default].merge(ORDERING_FALLBACK)
      end
    end
  end


  # Example:
  # GET /authors?sort=name,-id,+created_at
  # Returns:
  # { name: :asc, id: :desc, created_at: :asc }
  # If no sorting params are provided, return the default ordering
  # Add the ORDERING_FALLBACK as the last element of the ordering hash, only if the ORDERING_FALLBACK field is not present in the sorting params
  def sorting_params_parsed
    return ordering_default unless sorting_params
    ordering = {}
    sorting_params.split(',').each do |attr|
      sort_sign = attr[0] =~ /^[+-]$/ ? attr[0] : '+'
      field = attr[0] =~ /^[+-]$/ ? attr[1..] : attr
      ordering[field.to_sym] = sort_sign == '+' ? :asc : :desc
    end
    ordering.merge!(ORDERING_FALLBACK) unless ordering.key?(ORDERING_FALLBACK.keys.first)
    ordering
  end
  
  private

  def sorting_params
    params[:sort]
  end
end