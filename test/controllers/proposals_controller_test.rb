require "test_helper"

class ProposalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @proposal = proposals(:proposal_one)
    @project = @proposal.project

    @freelancer = users(:freelancer_one)
    @other_freelancer = users(:freelancer_two)
    @client = users(:client_one)
  end

  test "freelancer cannot create duplicate proposal for same project" do
    sign_in_as(@freelancer)

    assert_no_difference("Proposal.count") do
      post proposals_url, params: {
        proposal: {
          message: "Duplicate proposal",
          bid_amount: 1200,
          project_id: @project.id
        }
      }
    end
  end

  test "client cannot create proposal" do
    sign_in_as(@client)

    post proposals_url, params: {
      proposal: {
        message: "Invalid proposal",
        bid_amount: 1000,
        project_id: @project.id
      }
    }

    assert_redirected_to projects_path
  end

  test "proposal owner can view proposal" do
    sign_in_as(@freelancer)

    get proposal_url(@proposal)
    assert_response :success
  end

  test "proposal owner can edit proposal" do
    sign_in_as(@freelancer)

    get edit_proposal_url(@proposal)
    assert_response :success
  end

  test "non-owner freelancer cannot edit proposal" do
    sign_in_as(@other_freelancer)

    get edit_proposal_url(@proposal)

    assert_redirected_to project_path(@proposal.project)
  end

  test "proposal owner can update proposal" do
    sign_in_as(@freelancer)

    patch proposal_url(@proposal), params: {
      proposal: {
        message: "Updated message",
        bid_amount: 1300
      }
    }

    assert_redirected_to proposal_url(@proposal)
  end

  test "proposal owner can destroy proposal" do
    sign_in_as(@freelancer)

    assert_difference("Proposal.count", -1) do
      delete proposal_url(@proposal)
    end

    assert_redirected_to proposals_path
  end

  test "non-owner cannot destroy proposal" do
    sign_in_as(@other_freelancer)

    delete proposal_url(@proposal)

    assert_redirected_to project_path(@proposal.project)
  end

end
