class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body
  has_many :comments, if: :include_comments?

  def include_comments?
    instance_options[:include_list]&.include?(:comments)
  end
end
