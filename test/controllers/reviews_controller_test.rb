require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @review = reviews(:client_review)
    @project = @review.project

    @client = users(:client_one)
    @freelancer = users(:freelancer_one)
    @other_freelancer = users(:freelancer_two)
  end

  test "client cannot create second review for same project" do
    sign_in_as(@client)

    assert_no_difference("Review.count") do
      post reviews_url, params: {
        review: {
          rating: 5,
          comment: "Duplicate review"
        }
      }
    end
  end

  test "rejected freelancer gets 404 when attempting to create review" do
    sign_in_as(@other_freelancer)

    post reviews_url, params: {
      review: {
        rating: 1,
        comment: "Invalid"
      }
    }

    assert_response :not_found
  end

  test "review owner can view review" do
    sign_in_as(@client)

    get review_url(@review)
    assert_response :success
  end

  test "review owner can edit review" do
    sign_in_as(@client)

    get edit_review_url(@review)
    assert_response :success
  end

  test "non-owner cannot edit review" do
    sign_in_as(@other_freelancer)

    get edit_review_url(@review)
    assert_redirected_to project_path(@project)
  end

  test "review owner can update review" do
    sign_in_as(@client)

    patch review_url(@review), params: {
      review: {
        rating: 4,
        comment: "Updated comment"
      }
    }

    assert_redirected_to review_url(@review)
  end

  test "review owner can destroy review" do
    sign_in_as(@client)

    assert_difference("Review.count", -1) do
      delete review_url(@review)
    end

    assert_redirected_to reviews_path
  end

  test "non-owner cannot destroy review" do
    sign_in_as(@other_freelancer)

    delete review_url(@review)
    assert_redirected_to project_path(@project)
  end
end
