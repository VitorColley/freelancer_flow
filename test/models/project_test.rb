require "test_helper"

class ProjectTest < ActiveSupport::TestCase

  test "valid project" do
    project = projects(:website_project)
    assert project.valid?
  end

  test "requires title" do
    project = projects(:website_project)
    project.title = nil
    assert_not project.valid?
  end

  test "budget must be positive" do
    project = projects(:website_project)
    project.budget = -100
    assert_not project.valid?
  end

  test "status must be valid" do
    project = projects(:website_project)
    project.status = "archived"
    assert_not project.valid?
  end

  test "belongs to a client" do
    project = projects(:website_project)
    assert project.client.client?
  end

end
