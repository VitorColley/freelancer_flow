require "test_helper"

class ProposalTest < ActiveSupport::TestCase

 test "valid proposal" do
    proposal = proposals(:proposal_one)
    assert proposal.valid?
  end

  test "requires a message" do
    proposal = proposals(:proposal_one)
    proposal.message = nil
    assert_not proposal.valid?
  end

  test "bid amount must be positive" do
    proposal = proposals(:proposal_one)
    proposal.bid_amount = -50
    assert_not proposal.valid?
  end

  test "status must be valid" do
    proposal = proposals(:proposal_one)
    proposal.status = "maybe"
    assert_not proposal.valid?
  end

  test "belongs to a freelancer" do
    proposal = proposals(:proposal_one)
    assert proposal.freelancer.freelancer?
  end

end
