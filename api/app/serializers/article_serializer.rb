class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body
  has_many :comments, if: :include_comments?

  def include_comments?
    Rails.logger.info "Options: #{@instance_options.inspect}"
    instance_options[:include_list]&.include?(:comments)
  end
end
