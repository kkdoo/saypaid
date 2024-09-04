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
class Layer < ApplicationRecord
  include Discarded

  STATUSES_LIST = %w[draft active disabled].freeze

  belongs_to :account
  has_many :plans
  has_many :customers
  has_many :subscriptions
  has_many :pricing_tables
  has_many :tokens

  enum :status, STATUSES_LIST.zip(STATUSES_LIST).to_h

  after_create :generate_tokens

  protected

  def generate_tokens
    tokens.create!(kind: 'secret')
  end
end
