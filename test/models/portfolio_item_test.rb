require "test_helper"

class PortfolioItemTest < ActiveSupport::TestCase

  test "valid portfolio item" do
    portfolio_item = portfolio_items(:freelancer_one_portfolio)
    assert portfolio_item.valid?
  end

  test "requires a title" do
    portfolio_item = portfolio_items(:freelancer_one_portfolio)
    portfolio_item.title = nil
    assert_not portfolio_item.valid?
  end

  test "requires a description" do
    portfolio_item = portfolio_items(:freelancer_one_portfolio)
    portfolio_item.description = nil
    assert_not portfolio_item.valid?
  end

  test "belongs to a freelancer" do
    portfolio_item = portfolio_items(:freelancer_one_portfolio)
    assert portfolio_item.freelancer.freelancer?
  end
end
