# == Schema Information
#
# Table name: customers
#
#  id           :uuid             not null, primary key
#  discarded_at :datetime
#  email        :string
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  layer_id     :uuid             not null
#
# Indexes
#
#  index_customers_on_discarded_at  (discarded_at)
#
class Customer < ApplicationRecord
  include Discard::Model

  belongs_to :layer
  has_many :subscriptions

  def object_type
    'customer'
  end
end
