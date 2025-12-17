require "test_helper"

class ReviewTest < ActiveSupport::TestCase

  test "valid review" do
    review = reviews(:client_review)
    assert review.valid?
  end

  test "rating must be between 1 and 5" do
    review = reviews(:client_review)
    review.rating = 6
    assert_not review.valid?
  end

  test "requires comment" do
    review = reviews(:client_review)
    review.comment = nil
    assert_not review.valid?
  end

end
