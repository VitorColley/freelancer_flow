require 'test_helper'
require 'test_helpers/fake_payment_gateway_test_helper'

class PaymentProcessorTest < ActiveSupport::TestCase

    test "creates a checkout session with correct parameters" do
        project = projects(:mobile_app_project)
        project.update!(status: "completed")
        
        payment_processor = Payments::PaymentProcessor.new(
            project: project,
            gateway: FakePaymentGateway.new
        )

        session = payment_processor.checkout!

        assert_equal "fake_session_id", session.id
        assert_equal "/fake_checkout", session.url
    end

    test "raises error if project is not completed" do
        project = projects(:website_project)
        
        payment_processor = Payments::PaymentProcessor.new(
            project: project,
            gateway: FakePaymentGateway.new
        )

        assert_raises(Payments::PaymentProcessor::PaymentError) do
            session = payment_processor.checkout!
            payment_processor.checkout!
        end
    end
end