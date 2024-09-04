RSpec.shared_examples 'discarded' do
  let!(:subject) { create(factory_name) }
  let!(:discarded) { create(factory_name, discarded_at: Time.now) }
  let!(:list) { create_list(factory_name, 2) }

  describe "#discarded_at" do
    it { should have_db_column(:discarded_at).of_type(:datetime) }
    it { should have_db_index(:discarded_at) }
  end

  it 'kept will show less than unscoped' do
    expect(described_class.unscoped.count).to be > described_class.kept.count
  end

  it 'show only kept by default' do
    expect(described_class.all.count).to eq(3)
    expect(described_class.all.pluck(:id)).to eq(described_class.kept.pluck(:id))
  end

  context '#discard!' do
    it 'discard will mark record as discarded' do
      expect do
        subject.discard!
      end.to change { described_class.count }.from(3).to(2)
    end

    it 'discard will not delete anything in real' do
      expect do
        subject.discard!
      end.to_not change { described_class.unscoped.count }.from(4)
    end
  end

  context '#discard' do
    it 'discard will mark record as discarded' do
      expect do
        subject.discard
      end.to change { described_class.count }.from(3).to(2)
    end

    it 'discard will not delete anything in real' do
      expect do
        subject.discard
      end.to_not change { described_class.unscoped.count }.from(4)
    end
  end

  it 'cannot be discarded second time' do
    expect do
      discarded.discard!
    end.to raise_error(Discard::RecordNotDiscarded)
  end
end
