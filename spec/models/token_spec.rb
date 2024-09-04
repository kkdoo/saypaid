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
require 'rails_helper'

RSpec.describe Token, type: :model do
  context 'associations' do
    it { should belong_to(:layer) }
  end

  context 'validations' do
    subject { build(:token) }

    it { should validate_presence_of(:key) }
    it { should validate_presence_of(:kind) }
    it { should have_secure_token(:key) }
    it { should validate_uniqueness_of(:key) }
  end

  context 'discarded' do
    before :each do
      # stub api keys generation to pass quantity spec
      allow_any_instance_of(Layer).to receive(:generate_tokens)
    end

    let(:factory_name) { :token }
    it_behaves_like 'discarded'
  end
end
