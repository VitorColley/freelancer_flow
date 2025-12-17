require "test_helper"

class SkillTest < ActiveSupport::TestCase

  test "valid skill" do
    skill = skills(:ruby)
    assert skill.valid?
  end

  test "requires name" do
    skill = Skill.new
    assert_not skill.valid?
  end

  test "name must be unique" do
    duplicate = Skill.new(name: skills(:ruby).name)
    assert_not duplicate.valid?
  end
  
end
