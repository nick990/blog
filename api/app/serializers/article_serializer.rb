# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :integer
#
# Indexes
#
#  index_articles_on_author_id  (author_id)
#
# Foreign Keys
#
#  author_id  (author_id => authors.id)
#
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
