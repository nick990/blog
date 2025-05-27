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
class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :author, optional: true

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
end
