# == Schema Information
#
# Table name: webhook_events
#
#  id                  :uuid             not null, primary key
#  status              :integer          default("pending"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  event_id            :uuid             not null
#  webhook_endpoint_id :uuid             not null
#
FactoryBot.define do
  factory :webhook_event do
    event
    webhook_endpoint
    status { 'pending' }
  end
end
