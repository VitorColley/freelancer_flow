# This class serves as an interface for different payment gateways.
module Payments
    class PaymentGateway
        def create_checkout_session(amount:, metadata:)
            # This method should be implemented by subclasses for specific payment gateways.
            # Suggested by Copilot.
            raise NotImplementedError, "Gateway must implement create_checkout_session"
        end
    end
end