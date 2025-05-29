class ApplicationController < ActionController::API

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

  # Parse the filtering params.
  # The filtering params are passed as a hash of hashes.
  # The key of the hash is the field to filter on.
  # The value of the hash is a hash with the operator and the value.
  # The operator is the operator to use for the filter.
  # The value is the value to filter on.
  # The operator can be:
  # - eq: equal to  (default)
  # - neq: not equal to
  # - gt: greater than
  # - gte: greater than or equal to
  # - lt: less than
  # - lte: less than or equal to
  # - in: in the list
  # - not_in: not in the list
  # - like: like
  # - not_like: not like
  # - ilike: case insensitive like
  # - not_ilike: case insensitive not like
  # - scope_<XYZ>: use a scope with the name XYZ
  # Example:
  # GET /authors?filter[name]=John&filter[id]=1
  # Returns:
  # { name: { eq: "John" }, id: { eq: 1 } }
  # 
  # Advanced filtering:
  # GET /products?filter[price][gte]=100
  # Returns:
  # { price: { gte: 100 } }
  #
  # GET /products?filter[price][lte]=100
  # Returns:
  # { price: { lte: 100 } }
  # 
  #
  # If no filtering params are provided, return an empty hash
  def filtering_params_parsed
    filtering = {}
    return filtering unless filtering_params
    filtering_params.each do |key, value|
      field = key.to_sym
      operator = :eq
      filter_value = value
      if value.is_a?(Hash)
        operator = value.keys.first.to_sym
        filter_value = value[operator].to_s
      end
      filtering[field] = {operator => filter_value}
    end
    filtering
  end

  private
  def sorting_params
    params[:sort]
  end

  def filtering_params
    params[:filter].permit!.to_h
  end
end
