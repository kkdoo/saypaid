# == Schema Information
#
# Table name: accounts
#
#  id                  :uuid             not null, primary key
#  discarded_at        :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  default_currency_id :string(5)        not null
#
# Indexes
#
#  index_accounts_on_discarded_at  (discarded_at)
#
FactoryBot.define do
  factory :account do
    default_currency { Currency.find('USD') }
  end
end
