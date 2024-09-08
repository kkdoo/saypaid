# == Schema Information
#
# Table name: events
#
#  id          :uuid             not null, primary key
#  data        :text             not null
#  name        :string           not null
#  object_type :string           not null
#  status      :integer          default("pending"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  layer_id    :uuid             not null
#
FactoryBot.define do
  factory :event do
    layer
    name { 'customers.create' }
    object_type { 'customer' }
    data { { id: 'some_id' }.to_json }
  end
end
