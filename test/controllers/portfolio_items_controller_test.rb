require "test_helper"

class PortfolioItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @portfolio_item = portfolio_items(:one)
  end

  test "should get index" do
    get portfolio_items_url
    assert_response :success
  end

  test "should get new" do
    get new_portfolio_item_url
    assert_response :success
  end

  test "should create portfolio_item" do
    assert_difference("PortfolioItem.count") do
      post portfolio_items_url, params: { portfolio_item: { description: @portfolio_item.description, freelancer_id: @portfolio_item.freelancer_id, title: @portfolio_item.title, url: @portfolio_item.url } }
    end

    assert_redirected_to portfolio_item_url(PortfolioItem.last)
  end

  test "should show portfolio_item" do
    get portfolio_item_url(@portfolio_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_portfolio_item_url(@portfolio_item)
    assert_response :success
  end

  test "should update portfolio_item" do
    patch portfolio_item_url(@portfolio_item), params: { portfolio_item: { description: @portfolio_item.description, freelancer_id: @portfolio_item.freelancer_id, title: @portfolio_item.title, url: @portfolio_item.url } }
    assert_redirected_to portfolio_item_url(@portfolio_item)
  end

  test "should destroy portfolio_item" do
    assert_difference("PortfolioItem.count", -1) do
      delete portfolio_item_url(@portfolio_item)
    end

    assert_redirected_to portfolio_items_url
  end
end
