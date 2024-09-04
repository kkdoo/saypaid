# == Schema Information
#
# Table name: prices
#
#  id              :uuid             not null, primary key
#  flat_fee        :decimal(20, 5)   default(0.0)
#  type            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  plan_version_id :uuid             not null
#
FactoryBot.define do
  factory :flat_price, class: 'Prices::Flat' do
    plan_version
    flat_fee { 10.0 }
  end
end
