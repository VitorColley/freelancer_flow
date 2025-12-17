require "test_helper"

class SkillsControllerTest < ActionDispatch::IntegrationTest
  
  setup do
    @skill = skills(:ruby)
    @user  = users(:client_one)
  end

  test "anyone can view skills index" do
    get skills_url
    assert_response :success
  end

  test "anyone can view a skill" do
    get skill_url(@skill)
    assert_response :success
  end

  test "unauthenticated users cannot access new skill page" do
    get new_skill_url
    assert_redirected_to new_session_path
  end

  test "authenticated user can access new skill page" do
    sign_in_as(@user)

    get new_skill_url
    assert_response :success
  end

  test "authenticated user can create skill" do
    sign_in_as(@user)

    assert_difference("Skill.count", 1) do
      post skills_url, params: { skill: { name: "GraphQL" } }
    end

    assert_redirected_to skill_url(Skill.last)
  end

  test "unauthenticated user cannot create skill" do
    assert_no_difference("Skill.count") do
      post skills_url, params: { skill: { name: "Hacking" } }
    end

    assert_redirected_to new_session_path
  end

end
