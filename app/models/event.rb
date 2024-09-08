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
class Event < ApplicationRecord
  belongs_to :layer
  has_many :webhook_events
  has_many :webhook_endpoints, through: :webhook_events

  enum :status, { pending: 0, done: 1, failed: 2 }

  validates :data, :name, :object_type, :status, presence: true

  scope :ordered, -> { order(created_at: :desc, name: :asc) }

  after_commit :deliver_to_webhook_endpoints, on: :create

  protected

  def deliver_to_webhook_endpoints
    DeliverEventJob.perform_async(id)
  end
end
