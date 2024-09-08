module SubscriptionsHelpers
  def create_subscription(layer:, attrs:, version:, customer:)
    version_id = SecureRandom.uuid

    sub = layer.subscriptions.create!(
      customer:,
      current_version_id: version_id,
      **attrs,
    )

    sub.subscription_versions.create!(
      id: version_id,
      plan: create(:plan),
      **attributes_for(:subscription_version),
      **version,
    )

    sub
  end
end

RSpec.configure do |config|
  config.include SubscriptionsHelpers
end
