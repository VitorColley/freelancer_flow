require "test_helper"

class PortfolioItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @portfolio_item = portfolio_items(:freelancer_one_portfolio)

    @freelancer = users(:freelancer_one)
    @other_freelancer = users(:freelancer_two)
    @client = users(:client_one)
  end

  test "index is protected and redirects unauthenticated users" do
    get portfolio_items_url
    assert_redirected_to projects_path
  end

  test "freelancer can access new portfolio item page" do
    sign_in_as(@freelancer)

    get new_portfolio_item_url
    assert_response :success
  end

  test "client cannot access new portfolio item page" do
    sign_in_as(@client)

    get new_portfolio_item_url
    assert_redirected_to projects_path
  end

  test "freelancer can create portfolio item" do
    sign_in_as(@freelancer)

    assert_difference("PortfolioItem.count", 1) do
      post portfolio_items_url, params: {
        portfolio_item: {
          title: "New Portfolio Item",
          description: "Sample work",
          url: "https://github.com/example"
        }
      }
    end

    assert_redirected_to portfolio_item_url(PortfolioItem.last)
  end

  test "client cannot create portfolio item" do
    sign_in_as(@client)

    post portfolio_items_url, params: {
      portfolio_item: {
        title: "Invalid",
        url: "https://example.com"
      }
    }

    assert_redirected_to projects_path
  end

  test "portfolio owner can edit portfolio item" do
    sign_in_as(@freelancer)

    get edit_portfolio_item_url(@portfolio_item)
    assert_response :success
  end

  test "non-owner freelancer cannot edit portfolio item" do
    sign_in_as(@other_freelancer)

    get edit_portfolio_item_url(@portfolio_item)
    assert_redirected_to portfolio_items_path
  end

  test "portfolio owner can update portfolio item" do
    sign_in_as(@freelancer)

    patch portfolio_item_url(@portfolio_item), params: {
      portfolio_item: {
        title: "Updated title"
      }
    }

    assert_redirected_to portfolio_item_url(@portfolio_item)
  end

  test "portfolio owner can destroy portfolio item" do
    sign_in_as(@freelancer)

    assert_difference("PortfolioItem.count", -1) do
      delete portfolio_item_url(@portfolio_item)
    end

    assert_redirected_to portfolio_items_url
  end

  test "non-owner freelancer cannot destroy portfolio item" do
    sign_in_as(@other_freelancer)

    delete portfolio_item_url(@portfolio_item)
    assert_redirected_to portfolio_items_path
  end
end
