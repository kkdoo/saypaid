module Entities
  class Subscription < BaseEntity
    expose :id
    expose :status
    expose :pay_in_advance

    expose :customer, using: Entities::Customer
    expose :current_version, merge: true, using: Entities::SubscriptionVersion
  end
end
