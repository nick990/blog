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

Consente di definire i filtri nel query param `filter`.

```bash
# Formato query param
filter[field][operator?]=value
# Esempi
filter[name]=John
filter[id]=1
filter[price][gte]=100 # price >= 100
filter[price][lte]=100 # price <= 100
```

## Operatori

Gli operatori sono mappati sui metodi Arel.

- `eq` (default)
  <br>Se non specificato, viene usato l'operatore `eq`.
  ```bash
  # Esempio:
  filter[name]=John
  filter[name][eq]=John
  ```
- `neq`
  ```bash
  # Esempio:
  filter[name][neq]=John
  ```
- `gt`
  ```bash
  # Esempio:
  filter[price][gt]=100
  ```
- `gte`
  ```bash
  # Esempio:
  filter[price][gte]=100
  ```
- `lt`
  ```bash
  # Esempio:
  filter[price][lt]=100
  ```
- `lte`
  ```bash
  # Esempio:
  filter[price][lte]=100
  ```
- `in`
  ```bash
  # Esempio:
  filter[name][in]=John,Jane,Jim
  ```
- `not_in`
  ```bash
  # Esempio:
  filter[name][not_in]=John,Jane,Jim
  ```
- `like`
  ```bash
  # Esempio:
  filter[name][like]=John
  filter[name][like]=%oh%
  ```
- `not_like`
  ```bash
  # Esempio:
  filter[name][not_like]=John
  filter[name][not_like]=%oh%
  ```

## Usage

```ruby
class AuthorsController < ApplicationController
  include Filterable

  def index
    @authors = filter_entities(@Author.all)
    render json: AuthorSerializer.new(@authors).serializable_hash
  end

end

```

# Sortable

Consente di definire l'ordinamento nel query param `sort`.

```bash
# Formato query param
sort=field1,+field2,-field3
# => ORDER BY field1 asc, field2 asc, field3 desc
# + : ASC (opzionale)
# - : DESC
```

## USAGE

```ruby
class ApplicationController < ActionController::API
  include Sortable
end


class AuthorsController < ApplicationController
  sortable default: {name: :asc}

  def index
    @authors = Author.all.order(sorting_params_parsed)
    render json: AuthorSerializer.new(@authors).serializable_hash
  end

end

# Esemtpi di richieste

[GET] /authors?filter[name]=John&filter[age][gt]=20
# => SELECT * FROM authors WHERE name = 'John' AND age > 20

[GET] /authors?filter[name][in]=John,Jane,Jim
# => SELECT * FROM authors WHERE name IN ('John', 'Jane', 'Jim')


```

**Ordinamento di default**

È possibile definire un ordinamento di default per un controller.<br>
Se non specificato, viene usato l'ordinamento per `id DESC`.
L'ordinamento di default viene usato se non viene passata nessuna regola di ordinamento nei params.<br>

**Ordinamento di fallback**

Se nelle regole di ordinamento da applicare non è presente il campo `id`, viene aggiunto in coda l'ordinamento di fallback: `id DESC`.<br>
Viene aggiunto anche all'ordinamento di default.<br>

## Esempi

```ruby
class ApplicationController < ActionController::API
  include Sortable
end

class AuthorsController < ApplicationController
    sortable default: {name: :asc}
    # DEFAULT : name asc, id desc
    # FALLBACK : id desc
end

class ArticlesController < ApplicationController
    # DEFAULT : id desc
    # FALLBACK : id desc
end

# Esempi di richieste

[GET] /authors
# => Order by name asc, id desc
# Il fallback viene aggiunto al default

[GET] /authors?sort=-created_at
# =>Order by name created_at desc, id desc
# Il fallback viene aggiunto all'ordinamento passato

[GET] /authors?sort=-name,id
# => Order by name desc, id asc
# Il fallback non viene aggiunto, perché l'id è presente nell'ordinamento passato

[GET] /articles
# => Order by id desc
# default = fallback
```
