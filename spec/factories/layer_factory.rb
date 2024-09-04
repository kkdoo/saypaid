# == Schema Information
#
# Table name: layers
#
#  id           :uuid             not null, primary key
#  discarded_at :datetime
#  livemode     :boolean          default(FALSE), not null
#  name         :string           not null
#  status       :string           default("draft"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :uuid             not null
#
# Indexes
#
#  index_layers_on_discarded_at  (discarded_at)
#
FactoryBot.define do
  factory :layer do
    account
    name { 'Test layer' }
    status { 'active' }
    livemode { false }
  end
end
