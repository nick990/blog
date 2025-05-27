class BaseSerializer
  include JSONAPI::Serializer

  set_key_transform :camel_lower

  link :self do |object|
    object.resource_link
  end
end