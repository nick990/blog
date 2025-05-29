module Sortable
  extend ActiveSupport::Concern
  
  # Parse the sorting params
  # Example:
  # GET /authors?sort=name,-id,+created_at
  # Returns:
  # { name: :asc, id: :desc, created_at: :asc }
  # If no sorting params are provided, return the default ordering (id: :asc)
  # Add the default ordering as the last element of the ordering hash, only if the id field is not present in the sorting params
  def sorting_params_parsed
    ordering_default = {id: :asc}
    return ordering_default unless sorting_params
    ordering = {}
    sorting_params.split(',').each do |attr|
      sort_sign = attr[0] =~ /^[+-]$/ ? attr[0] : '+'
      field = attr[0] =~ /^[+-]$/ ? attr[1..] : attr
      ordering[field.to_sym] = sort_sign == '+' ? :asc : :desc
    end
    ordering.merge!(ordering_default) unless ordering.key?(:id)
    ordering
  end
  
  private

  def sorting_params
    params[:sort]
  end
end