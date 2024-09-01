# == Schema Information
#
# Table name: currencies
#
#  id         :string(5)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Currency < ApplicationRecord
  has_many :plans
  has_many :accounts, foreign_key: "default_currency_id"
end
