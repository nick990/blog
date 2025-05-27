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
class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body
  has_many :comments, if: :include_comments?
  belongs_to :author, if: :include_author?
  
  def include_comments?
    instance_options[:include_list]&.include?(:comments)
  end

  def include_author?
    instance_options[:include_list]&.include?(:author)
  end
end
