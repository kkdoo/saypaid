# == Schema Information
#
# Table name: tokens
#
#  id           :uuid             not null, primary key
#  discarded_at :datetime
#  expired_at   :datetime
#  key          :string           not null
#  kind         :integer          not null
#  last_used_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  layer_id     :uuid             not null
#
# Indexes
#
#  index_tokens_on_discarded_at  (discarded_at)
#  index_tokens_on_key           (key) UNIQUE WHERE (discarded_at IS NULL)
#
FactoryBot.define do
  factory :token do
    layer
    kind { 'secret' }
  end
end
