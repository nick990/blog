# Creazione progetto from scratch con versioni specifiche

Supponiamo di voler creare un progetto rails con le seguenti versioni:

- ruby 3.3.4
- rails 2.7.7.1

```bash
# Passo momentaneamente alla versione Ruby richiesta
asdf global ruby 3.3.4
# Installo la versione di Rails richiesta
gem install rails --version=7.2.2.1
# Creo il progetto
rails _7.2.2.1_ new blog
cd blog
# Settiamo la versione locale di ruby
asdf local ruby 3.3.4
# Ripristiamo eventulamente la versione di Ruby globale precedente
asdf global ruby X.Y.Z
```

Verifichiamo le versioni nella cartella del progetto:

```bash
# Ruby
ruby --version
cat .ruby-version
# Rails
rails --version
cat Gemfile | grep 'gem "rails"'
```

# Run

```bash
bundle exec rails s
```

# Installare le Gemme

Aggiungere la gemma al `Gemfile`, installiamo per esempio `rspec`:

```bash
gem "rspec"
```

Installare con bundle:

```bash
bundle install
```

# Annotate

La gemma [annotate](https://rubygems.org/gems/annotate) aggiunge commenti riepilogativi dello schema a: modelli, fixtures, test, rotte.

Installazione:

```bash
group :development do
  gem "annotate"
end
```

```bash
bundle install
```

Creazione commenti sui modelli:

```bash
bundle exec annotate --models
```

È possibile fare in modo che annotate venga eseguito automaticamente ogni volta che si esegue `rails db:migrate`:

```bash
bundle exec rails g annotate:install
```

Questo crea un file `lib/tasks/auto_annotate_models.rake` che può essere modificato per personalizzare il comportamento di annotate.

# Serializer

## Generatore Rails

```bash
rails g serializer article
rails g serializer comment
```

## AMS - Active Model Serializer

Gemma: `active-model-serializer`.

## JSON:API Serializer

Gemma: `jsonapi-serializer`

Repo: [github.com/jsonapi-serializer/jsonapi-serializer](https://github.com/jsonapi-serializer/jsonapi-serializer)

## JSON API

Proposta di standard per la serializzazione di dati JSON.

```json
{
  "data": {
    "id": "1",
    "type": "article",
    "attributes": {
      "id": 1,
      "title": "First article",
      "body": "This is my first article!"
    },
    "relationships": {
      //Belongs to
      "author": {
        "data": {
          "id": "9",
          "type": "author"
        },
        "links": {
          "related": "/authors/9"
        }
      },
      "comments": {
        "meta": {
          "count": 0
        },
        "links": {
          "related": "/articles/2/comments"
        }
      }
    },
    "links": {
      "self": "/articles/1"
    }
  }
}
```
