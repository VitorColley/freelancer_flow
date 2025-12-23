module Payments
    class PaymentProcessor
        class PaymentError < StandardError; end

        # Initializes the payment processor with a project and a payment gateway.
        def initialize(project:, gateway: StripeGateway.new)
            @project = project
            @gateway = gateway
        end

        # Processes the checkout for the given project.
        def checkout!
            validate_project!

            # Create a checkout session using the payment gateway.
            @gateway.create_checkout_session(
                amount: @project.budget,
                metadata: { project_id: @project.id }
            )
        end

        private
        # Validates that the project is eligible for payment processing.
        def validate_project!
            raise PaymentError, "Project must be completed" unless @project.status == 'completed'
            raise PaymentError, "Invoice missing" unless @project.invoice.present?
        end
    end
end