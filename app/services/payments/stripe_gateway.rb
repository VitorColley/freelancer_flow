# Stripe payment gateway implementation
module Payments
    class StripeGateway < PaymentGateway
        def create_checkout_session(amount:, metadata:)
            session = Stripe::Checkout::Session.create(
                payment_method_types: ['card'],
                line_items: [{
                    price_data: {
                        currency: 'eur',
                        product_data: {
                            name: 'Freelancer Flow Payment',
                        },
                        unit_amount: (amount*100).to_i,
                    },
                    quantity: 1,
                }],
                mode: 'payment',
                success_url: Rails.application.routes.url_helpers.success_payments_url + '?session_id={CHECKOUT_SESSION_ID}',
                cancel_url: Rails.application.routes.url_helpers.cancel_payments_url,
                metadata: metadata
            )
            session
        end
    end
end