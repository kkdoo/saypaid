module Entities
  class SubscriptionVersion < BaseEntity
    with_options(format_with: :timestamp) do
      expose :start_at
      expose :trial_end
      expose :current_period_start
      expose :current_period_end
      expose :cancelation_time
      expose :terminate_at
    end

    expose :plan, using: Entities::Plan
  end
end
