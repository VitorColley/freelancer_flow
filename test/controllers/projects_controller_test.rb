require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:mobile_app_project)
    @client  = users(:client_one)
    @freelancer = users(:freelancer_one)
  end

  test "authenticated user can view projects index" do
    sign_in_as(@client)
    get projects_url
    assert_response :success
  end

  test "client can access new project page" do
    sign_in_as(@client)
    get new_project_url
    assert_response :success
  end

  test "freelancer cannot access new project page" do
    sign_in_as(@freelancer)
    get new_project_url
    assert_redirected_to projects_path
  end

  test "client can create project" do
    sign_in_as(@client)

    assert_difference("Project.count", 1) do
      post projects_url, params: {
        project: {
          title: "New Project",
          description: "Test project",
          budget: 1000
        }
      }
    end

    assert_redirected_to project_url(Project.last)
  end

  test "freelancer cannot create project" do
    sign_in_as(@freelancer)

    post projects_url, params: {
      project: {
        title: "Hack",
        description: "Should not work"
      }
    }

    assert_redirected_to projects_path
  end

  test "client can view own project" do
    sign_in_as(@client)
    get project_url(@project)
    assert_response :success
  end

  test "client can edit own project" do
    sign_in_as(@client)
    get edit_project_url(@project)
    assert_response :success
  end

  test "client cannot edit someone else's project" do
    other_client = User.create!(
      name: "Other Client",
      email_address: "other@example.com",
      password: "Password1234!",
      role: "client"
    )

    sign_in_as(other_client)
    get edit_project_url(@project)
    assert_redirected_to projects_path
  end

  test "client can update own project" do
    sign_in_as(@client)

    patch project_url(@project), params: {
      project: { title: "Updated title" }
    }

    assert_redirected_to project_url(@project)
  end

  test "client can destroy own project" do
    sign_in_as(@client)

    assert_difference("Project.count", -1) do
      delete project_url(@project)
    end

    assert_redirected_to projects_url
  end
end
