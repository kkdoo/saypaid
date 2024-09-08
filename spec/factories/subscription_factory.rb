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
  factory :base_subscription, class: 'Subscription' do
    layer
    customer
    status { 'created' }
    pay_in_advance { true }

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

      trait :active do
        status { 'active' }
        is_active_now { true }
      end

      trait :terminated do
        status { 'terminated' }
        is_active_now { false }
      end

      trait :trial do
        status { 'trial' }
        is_active_now { true }
      end
    end
  end
end
