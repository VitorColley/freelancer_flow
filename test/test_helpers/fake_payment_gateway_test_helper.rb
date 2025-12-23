require 'ostruct'

class FakePaymentGateway
    def create_checkout_session(amount:, metadata:)
        OpenStruct.new(
            id: "fake_session_id",
            url: "/fake_checkout",
            amount: amount,
            metadata: metadata
        )
    end
end