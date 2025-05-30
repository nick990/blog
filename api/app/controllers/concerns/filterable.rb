module Filterable
  extend ActiveSupport::Concern

  
  def filter_entities(entities)
    table = entities.arel_table
    filtering_params_parsed.each do |field, value|
      operator = value.keys.first
      filter_value = value[operator]
      case operator
      when :eq
        entities = entities.where(table[field].eq(filter_value))
      when :neq
        entities = entities.where.not(table[field].eq(filter_value))
      when :gt
        entities = entities.where(table[field].gt(filter_value))
      when :gte
        entities = entities.where(table[field].gteq(filter_value))
      when :lt
        entities = entities.where(table[field].lt(filter_value))
      when :lte
        entities = entities.where(table[field].lteq(filter_value))
      when :in
        entities = entities.where(table[field].in(filter_value.split(',')))
      when :not_in
        entities = entities.where.not(table[field].in(filter_value.split(',')))
      when :like
        entities = entities.where(table[field].matches(filter_value))
      when :not_like
      end
    end
    entities
  end
  
  private
  
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
  def filtering_params
    return {} unless params[:filter]
    params[:filter].permit!.to_h
  end
end