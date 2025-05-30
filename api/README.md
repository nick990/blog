# Resftul

Fornisce metodi di utilità sui modelli per implementare Restful API.

```ruby
class Article < ApplicationRecord
    include Restful
end

class Author < ApplicationRecord
    include Restful

    def self.resource_name
        "aaaaaaauthors"
    end
end

```

```ruby
Article.resource_name
# => "articles"

Author.resource_name
# => "aaaaaaauthors"

art = Article.new
art.resource_link
# => "/articles/1"

aut = Author.new
aut.resource_link
# => "/aaaaaaauthors/1"
```

Può essere usato nei serializers per generare i link alle risorse.

```ruby
class BaseSerializer
  include JSONAPI::Serializer

  link :self do |object|
    object.resource_link
  end
end
```

Risposta JSON:

```json
{
  "data": [
    {
      "id": "2",
      "type": "article",
      "attributes": {
        "id": 2,
        "title": "A new article",
        "body": "This is the body of the article"
      },
      "links": {
        "self": "/articles/2"
      }
    }
  ]
}
```

# Filterable

# Sortable
