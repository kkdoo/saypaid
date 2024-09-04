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
class Account < ApplicationRecord
  include Discarded

  has_many :layers
  belongs_to :default_currency, class_name: "Currency"
end
