# == Schema Information
#
# Table name: authors
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class AuthorTest < ActiveSupport::TestCase
  test "should not save author without name" do
    author = Author.new
    assert_not author.save, "Saved the author without a name"
  end

  test "should not save author with name less than 3 characters" do
    author = Author.new(name: "A")
    assert_not author.save, "Saved the author with a name less than 3 characters"
  end
end
