# == Schema Information
#
# Table name: subscriptions
#
#  id                 :uuid             not null, primary key
#  discarded_at       :datetime
#  is_active_now      :boolean          default(FALSE), not null
#  pay_in_advance     :boolean          not null
#  status             :integer          default("created"), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  current_version_id :uuid             not null
#  customer_id        :uuid             not null
#  layer_id           :uuid             not null
#
# Indexes
#
#  index_subscriptions_on_discarded_at  (discarded_at)
#
FactoryBot.define do
  factory :subscription do
    layer
    customer
    status { 'created' }
    pay_in_advance { true }

    before(:create) do |subscription|
      if subscription.subscription_versions.empty?
        subscription.current_version_id = SecureRandom.uuid
      end
    end

    after(:create) do |subscription|
      if subscription.subscription_versions.empty?
        create(:subscription_version, id: subscription.current_version_id, subscription: subscription)
      end
    end
  end
end
