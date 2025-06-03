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
require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "should not save article without title" do
    article = Article.new
    assert_not article.save, "Saved the article without a title"
  end

  test "should not save article without body" do
    article = Article.new(title: "MyString", author: authors(:one))
    assert_not article.save, "Saved the article without a body"
  end

  test "should not save article with body less than 10 characters" do
    article = Article.new(title: "MyString", body: "MyText", author: authors(:one))
    assert_not article.save, "Saved the article with a body less than 10 characters"
  end

end
