module SessionTestHelper
  def sign_in_as(user)
    # Defined session details
    Current.session = user.sessions.create!(
      user_agent: "Rails Test",
      ip_address: "127.0.0.1"
    )

    ActionDispatch::TestRequest.create.cookie_jar.tap do |cookie_jar|
      cookie_jar.signed[:session_id] = Current.session.id
      cookies["session_id"] = cookie_jar[:session_id]
    end
  end

  def sign_out
    Current.session&.destroy!
    cookies.delete("session_id")
  end
end

ActiveSupport.on_load(:action_dispatch_integration_test) do
  include SessionTestHelper
end
