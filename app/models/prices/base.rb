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
class Prices::Base < ApplicationRecord
  self.table_name = "prices"

  belongs_to :plan_version

  def kind
    raise "Not implemented"
  end
end
