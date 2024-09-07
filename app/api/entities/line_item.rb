module Entities
  class LineItem < BaseEntity
    expose :amount
    expose :plan, using: Entities::Plan do |line_item|
      line_item.subscription_version.plan
    end
  end
end
