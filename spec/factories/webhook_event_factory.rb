# == Schema Information
#
# Table name: webhook_endpoints
#
#  id           :uuid             not null, primary key
#  discarded_at :datetime
#  status       :integer          default("enabled"), not null
#  url          :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  layer_id     :uuid             not null
#
# Indexes
#
#  index_webhook_endpoints_on_discarded_at  (discarded_at)
#
FactoryBot.define do
  factory :webhook_event do
    event
    webhook_endpoint
    status { 'pending' }
  end
end
