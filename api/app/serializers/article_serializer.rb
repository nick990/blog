class ArticleSerializer < BaseSerializer
  attributes :id, :title, :body

  belongs_to :author, links: {
    related: ->(object) {
      object.author&.resource_link
    }
  }
  
  has_many :comments, lazy_load_data: true, links: {
    related: ->(object) {
      object.resource_link + "/" + Comment.resource_name
    }
  }, meta: ->(object, params) {
    { count: object.comments.count }
  }
end