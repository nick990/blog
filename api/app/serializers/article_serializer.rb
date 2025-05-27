class ArticleSerializer < BaseSerializer
  attributes :id, :title, :body
  belongs_to :author
  has_many :comments
end